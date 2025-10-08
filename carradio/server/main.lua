local QBCore = exports['qb-core']:GetCoreObject()

-- Server-side music data storage
local ActiveMusic = {} -- [vehicleId] = {url, volume, position, isPlaying, owner, coords}
local PlayerMusic = {} -- [playerId] = vehicleId
local MusicCache = {} -- URL cache for performance

-- Helper function to log events
local function LogEvent(message, data)
    if Config.Logging.enabled then
        print("[QB-CarMusic] " .. message)
        if Config.Debug and data then
            print("Data: " .. json.encode(data))
        end
    end
end

-- Get item callback
QBCore.Functions.CreateCallback('qb-carmusic:server:hasItem', function(source, cb, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local hasItem = Player.Functions.GetItemByName(item)
        cb(hasItem ~= nil)
    else
        cb(false)
    end
end)

-- Start/Update music
RegisterNetEvent('qb-carmusic:server:playMusic', function(musicData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local vehicleId = musicData.vehicleId
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    
    -- Store music data
    ActiveMusic[vehicleId] = {
        url = musicData.url,
        volume = musicData.volume,
        position = musicData.position or 0,
        isPlaying = musicData.isPlaying,
        owner = src,
        coords = playerCoords,
        title = musicData.title or "Unknown",
        artist = musicData.artist or "Unknown Artist",
        thumbnail = musicData.thumbnail or "",
        startTime = os.time()
    }
    
    PlayerMusic[src] = vehicleId
    
    -- Log the event
    if Config.Logging.logMusicEvents then
        LogEvent("Music started", {
            player = Player.PlayerData.name,
            citizenid = Player.PlayerData.citizenid,
            vehicle = vehicleId,
            url = musicData.url,
            volume = musicData.volume
        })
    end
    
    -- Sync with nearby players if volume is above threshold
    if musicData.volume >= Config.SharedVolumeThreshold then
        SyncMusicToNearbyPlayers(src, vehicleId)
    end
end)

-- Stop music
RegisterNetEvent('qb-carmusic:server:stopMusic', function(vehicleId)
    local src = source
    
    if ActiveMusic[vehicleId] then
        -- Log the event
        if Config.Logging.logMusicEvents then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                LogEvent("Music stopped", {
                    player = Player.PlayerData.name,
                    citizenid = Player.PlayerData.citizenid,
                    vehicle = vehicleId
                })
            end
        end
        
        -- Notify nearby players to stop music
        local coords = ActiveMusic[vehicleId].coords
        if coords then
            local nearbyPlayers = GetPlayersInArea(coords, Config.MaxDistance)
            for _, playerId in pairs(nearbyPlayers) do
                if playerId ~= src then
                    TriggerClientEvent('qb-carmusic:client:stopNearbyMusic', playerId, vehicleId)
                end
            end
        end
        
        -- Remove from active music
        ActiveMusic[vehicleId] = nil
        PlayerMusic[src] = nil
    end
end)

-- Update volume
RegisterNetEvent('qb-carmusic:server:updateVolume', function(vehicleId, volume)
    local src = source
    
    if ActiveMusic[vehicleId] and ActiveMusic[vehicleId].owner == src then
        ActiveMusic[vehicleId].volume = volume
        
        -- Log volume change if enabled
        if Config.Logging.logVolumeChanges then
            local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                LogEvent("Volume changed", {
                    player = Player.PlayerData.name,
                    vehicle = vehicleId,
                    volume = volume
                })
            end
        end
        
        -- Update nearby players
        if volume >= Config.SharedVolumeThreshold then
            SyncMusicToNearbyPlayers(src, vehicleId)
        else
            -- Stop music for nearby players if volume is too low
            StopMusicForNearbyPlayers(vehicleId)
        end
    end
end)

-- Seek music position
RegisterNetEvent('qb-carmusic:server:seekMusic', function(vehicleId, position)
    local src = source
    
    if ActiveMusic[vehicleId] and ActiveMusic[vehicleId].owner == src then
        ActiveMusic[vehicleId].position = position
        
        -- Sync with nearby players
        if ActiveMusic[vehicleId].volume >= Config.SharedVolumeThreshold then
            SyncMusicToNearbyPlayers(src, vehicleId)
        end
    end
end)

-- Sync music to specific player
RegisterNetEvent('qb-carmusic:server:syncMusic', function(targetPlayerId, musicData)
    local src = source
    
    if GetPlayerPing(targetPlayerId) > 0 then
        TriggerClientEvent('qb-carmusic:client:syncMusic', targetPlayerId, musicData)
    end
end)

-- Function to get players in area
function GetPlayersInArea(coords, radius)
    local players = {}
    local allPlayers = GetPlayers()
    
    for _, playerId in pairs(allPlayers) do
        local playerPed = GetPlayerPed(playerId)
        if playerPed and playerPed ~= 0 then
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(coords - playerCoords)
            
            if distance <= radius then
                table.insert(players, tonumber(playerId))
            end
        end
    end
    
    return players
end

-- Sync music to nearby players
function SyncMusicToNearbyPlayers(sourcePlayer, vehicleId)
    if not ActiveMusic[vehicleId] then return end
    
    local musicData = ActiveMusic[vehicleId]
    local coords = GetEntityCoords(GetPlayerPed(sourcePlayer))
    musicData.coords = coords
    
    local nearbyPlayers = GetPlayersInArea(coords, Config.MaxDistance)
    
    for _, playerId in pairs(nearbyPlayers) do
        if playerId ~= sourcePlayer then
            local playerCoords = GetEntityCoords(GetPlayerPed(playerId))
            local distance = #(coords - playerCoords)
            
            if distance <= Config.MaxDistance then
                -- Calculate volume based on distance
                local volumeMultiplier = 1.0
                if distance > Config.FadeDistance then
                    volumeMultiplier = 1.0 - ((distance - Config.FadeDistance) / (Config.MaxDistance - Config.FadeDistance))
                end
                
                local adjustedVolume = math.max(0, (musicData.volume - Config.SharedVolumeThreshold) * volumeMultiplier)
                
                if adjustedVolume > 0 then
                    TriggerClientEvent('qb-carmusic:client:syncMusic', playerId, {
                        vehicleId = vehicleId,
                        url = musicData.url,
                        volume = adjustedVolume,
                        position = musicData.position,
                        isPlaying = musicData.isPlaying,
                        coords = coords,
                        title = musicData.title,
                        artist = musicData.artist
                    })
                end
            end
        end
    end
end

-- Stop music for nearby players
function StopMusicForNearbyPlayers(vehicleId)
    if not ActiveMusic[vehicleId] then return end
    
    local coords = ActiveMusic[vehicleId].coords
    if coords then
        local nearbyPlayers = GetPlayersInArea(coords, Config.MaxDistance)
        for _, playerId in pairs(nearbyPlayers) do
            TriggerClientEvent('qb-carmusic:client:stopNearbyMusic', playerId, vehicleId)
        end
    end
end

-- Player disconnect cleanup
AddEventHandler('playerDropped', function(reason)
    local src = source
    local vehicleId = PlayerMusic[src]
    
    if vehicleId and ActiveMusic[vehicleId] then
        -- Stop music and notify nearby players
        StopMusicForNearbyPlayers(vehicleId)
        ActiveMusic[vehicleId] = nil
        PlayerMusic[src] = nil
        
        LogEvent("Player disconnected - music stopped", {
            playerId = src,
            vehicleId = vehicleId,
            reason = reason
        })
    end
end)

-- Cleanup thread for performance
CreateThread(function()
    while true do
        Wait(Config.Performance.cleanupInterval)
        
        -- Cleanup old music data
        local currentTime = os.time()
        for vehicleId, musicData in pairs(ActiveMusic) do
            if currentTime - musicData.startTime > 3600 then -- 1 hour old
                ActiveMusic[vehicleId] = nil
                LogEvent("Cleaned up old music data", {vehicleId = vehicleId})
            end
        end
        
        -- Cleanup disconnected players
        for playerId, vehicleId in pairs(PlayerMusic) do
            if GetPlayerPing(playerId) <= 0 then
                PlayerMusic[playerId] = nil
                if ActiveMusic[vehicleId] and ActiveMusic[vehicleId].owner == playerId then
                    StopMusicForNearbyPlayers(vehicleId)
                    ActiveMusic[vehicleId] = nil
                end
            end
        end
    end
end)

-- Admin commands
QBCore.Commands.Add('stopcarmusicall', 'Stop all car music (Admin Only)', {}, false, function(source, args))
    local src = source