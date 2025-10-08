local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local isUIOpen = false
local currentVehicle = nil
local musicData = {}
local nearbyPlayers = {}
local lastUpdate = 0
local musicVolume = Config.DefaultVolume
local lastSong = ""
local musicEnabled = false

-- Initialize
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

-- Main thread for vehicle detection and music management
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local isDriver = GetPedInVehicleSeat(vehicle, -1) == ped
        
        if vehicle ~= 0 and isDriver then
            if currentVehicle ~= vehicle then
                currentVehicle = vehicle
                if isUIOpen then
                    CloseUI()
                end
            end
            
            -- Update nearby players if music is playing
            if musicEnabled and musicData[vehicle] then
                UpdateNearbyPlayers(vehicle)
            end
        else
            if currentVehicle then
                if isUIOpen then
                    CloseUI()
                end
                currentVehicle = nil
            end
        end
        
        Wait(500)
    end
end)

-- Check if vehicle supports music
function IsVehicleAllowed(vehicle)
    if not vehicle or vehicle == 0 then return false end
    
    local vehicleClass = GetVehicleClass(vehicle)
    local vehicleHash = GetEntityModel(vehicle)
    
    -- Check if vehicle class is allowed
    if not Config.AllowedVehicleClasses[vehicleClass] then
        return false
    end
    
    -- Check if specific vehicle is restricted
    for _, restrictedHash in pairs(Config.RestrictedVehicles) do
        if vehicleHash == restrictedHash then
            return false
        end
    end
    
    return true
end

-- Check permissions
function HasPermission()
    if not PlayerData or not PlayerData.job then return false end
    
    -- Check blacklisted jobs
    for _, job in pairs(Config.Permissions.blacklistedJobs) do
        if PlayerData.job.name == job then
            if Config.Permissions.adminBypass and QBCore.Functions.HasPermission(source, 'admin') then
                return true
            end
            return false
        end
    end
    
    -- Check required item
    if Config.Permissions.requireItem then
        QBCore.Functions.TriggerCallback('qb-carmusic:server:hasItem', function(hasItem)
            return hasItem
        end, Config.Permissions.itemName)
    end
    
    return true
end

-- Open music UI
function OpenUI()
    if not currentVehicle or not IsVehicleAllowed(currentVehicle) then
        QBCore.Functions.Notify('This vehicle doesn\'t support music player', 'error')
        return
    end
    
    if not HasPermission() then
        QBCore.Functions.Notify('You don\'t have permission to use the music player', 'error')
        return
    end
    
    isUIOpen = true
    SetNuiFocus(true, true)
    
    local vehicleMusicData = musicData[currentVehicle] or {}
    
    SendNUIMessage({
        type = "openUI",
        vehicleId = currentVehicle,
        currentSong = vehicleMusicData.url or "",
        volume = vehicleMusicData.volume or Config.DefaultVolume,
        isPlaying = vehicleMusicData.isPlaying or false,
        position = vehicleMusicData.position or 0,
        duration = vehicleMusicData.duration or 0,
        title = vehicleMusicData.title or "",
        artist = vehicleMusicData.artist or "",
        thumbnail = vehicleMusicData.thumbnail or "",
        lastSong = lastSong
    })
end

-- Close music UI
function CloseUI()
    isUIOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeUI"
    })
end

-- Update nearby players for music sharing
function UpdateNearbyPlayers(vehicle)
    local vehicleCoords = GetEntityCoords(vehicle)
    local players = QBCore.Functions.GetPlayersFromCoords(vehicleCoords, Config.MaxDistance)
    
    for _, playerId in pairs(players) do
        local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(vehicleCoords - playerCoords)
        
        if distance <= Config.MaxDistance then
            local volumeMultiplier = 1.0
            if distance > Config.FadeDistance then
                volumeMultiplier = 1.0 - ((distance - Config.FadeDistance) / (Config.MaxDistance - Config.FadeDistance))
            end
            
            TriggerServerEvent('qb-carmusic:server:syncMusic', playerId, {
                vehicleId = vehicle,
                url = musicData[vehicle].url,
                volume = math.max(0, (musicData[vehicle].volume - Config.SharedVolumeThreshold) * volumeMultiplier),
                position = musicData[vehicle].position,
                isPlaying = musicData[vehicle].isPlaying,
                coords = vehicleCoords
            })
        end
    end
end

-- Start/Update music
function UpdateMusic(data)
    if not currentVehicle then return end
    
    musicData[currentVehicle] = data
    musicEnabled = data.isPlaying
    
    if data.isPlaying then
        musicVolume = data.volume
        lastSong = data.url
        
        -- Play sound effect
        if Config.SoundEffects.enabled then
            PlaySoundFrontend(-1, Config.SoundEffects.startSound, "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        end
        
        -- Show notification
        if Config.UISettings.showNotifications then
            QBCore.Functions.Notify('Music started: ' .. (data.title or 'Unknown'), 'success')
        end
        
        -- Sync with nearby players if volume is above threshold
        if data.volume >= Config.SharedVolumeThreshold then
            UpdateNearbyPlayers(currentVehicle)
        end
    else
        musicEnabled = false
        
        -- Play stop sound effect
        if Config.SoundEffects.enabled then
            PlaySoundFrontend(-1, Config.SoundEffects.stopSound, "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        end
        
        -- Stop music for nearby players
        TriggerServerEvent('qb-carmusic:server:stopMusic', currentVehicle)
    end
end

-- Validate YouTube URL
function ValidateYouTubeURL(url)
    local patterns = {
        "youtube%.com/watch%?v=([%w%-_]+)",
        "youtu%.be/([%w%-_]+)",
        "youtube%.com/embed/([%w%-_]+)",
        "youtube%.com/v/([%w%-_]+)"
    }
    
    for _, pattern in ipairs(patterns) do
        local videoId = string.match(url, pattern)
        if videoId then
            return true, videoId
        end
    end
    
    return false, nil
end

-- Validate direct audio URL
function ValidateDirectURL(url)
    local audioExtensions = {".mp3", ".ogg", ".wav", ".m4a", ".flac"}
    
    for _, ext in ipairs(audioExtensions) do
        if string.find(url:lower(), ext) then
            return true
        end
    end
    
    return false
end

-- Key bindings
RegisterCommand('carmusic', function()
    if currentVehicle then
        OpenUI()
    else
        QBCore.Functions.Notify('You need to be in a vehicle to use the music player', 'error')
    end
end, false)

RegisterCommand('musicToggle', function()
    if currentVehicle and musicData[currentVehicle] then
        local data = musicData[currentVehicle]
        data.isPlaying = not data.isPlaying
        UpdateMusic(data)
        
        SendNUIMessage({
            type = "toggleMusic",
            isPlaying = data.isPlaying
        })
    end
end, false)

-- Register key mappings
RegisterKeyMapping('carmusic', 'Open Car Music Player', 'keyboard', Config.UISettings.openKey)
RegisterKeyMapping('musicToggle', 'Toggle Car Music', 'keyboard', Config.UISettings.toggleKey)

-- NUI Callbacks
RegisterNUICallback('closeUI', function(data, cb)
    CloseUI()
    cb('ok')
end)

RegisterNUICallback('playMusic', function(data, cb)
    if not currentVehicle then
        cb('error')
        return
    end
    
    local url = data.url
    local volume = math.min(data.volume or Config.DefaultVolume, Config.MaxVolume)
    
    -- Validate URL
    local isValid = false
    local videoId = nil
    
    if string.find(url, "youtube") or string.find(url, "youtu.be") then
        isValid, videoId = ValidateYouTubeURL(url)
    else
        isValid = ValidateDirectURL(url)
    end
    
    if not isValid then
        QBCore.Functions.Notify('Invalid music URL', 'error')
        cb('error')
        return
    end
    
    -- Check blacklisted domains
    for _, domain in pairs(Config.BlacklistedDomains) do
        if string.find(url:lower(), domain:lower()) then
            QBCore.Functions.Notify('This domain is not allowed', 'error')
            cb('error')
            return
        end
    end
    
    local musicInfo = {
        vehicleId = currentVehicle,
        url = url,
        volume = volume,
        isPlaying = true,
        position = 0,
        title = data.title or "Unknown",
        artist = data.artist or "Unknown Artist",
        thumbnail = data.thumbnail or ""
    }
    
    UpdateMusic(musicInfo)
    TriggerServerEvent('qb-carmusic:server:playMusic', musicInfo)
    
    cb('ok')
end)

RegisterNUICallback('stopMusic', function(data, cb)
    if currentVehicle and musicData[currentVehicle] then
        musicData[currentVehicle].isPlaying = false
        UpdateMusic(musicData[currentVehicle])
        TriggerServerEvent('qb-carmusic:server:stopMusic', currentVehicle)
    end
    cb('ok')
end)

RegisterNUICallback('changeVolume', function(data, cb)
    if not currentVehicle or not musicData[currentVehicle] then
        cb('error')
        return
    end
    
    local volume = math.min(data.volume, Config.MaxVolume)
    musicData[currentVehicle].volume = volume
    
    if musicData[currentVehicle].isPlaying then
        UpdateMusic(musicData[currentVehicle])
        TriggerServerEvent('qb-carmusic:server:updateVolume', currentVehicle, volume)
    end
    
    -- Play volume change sound
    if Config.SoundEffects.enabled then
        PlaySoundFrontend(-1, Config.SoundEffects.volumeChangeSound, "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
    
    cb('ok')
end)

RegisterNUICallback('seekMusic', function(data, cb)
    if currentVehicle and musicData[currentVehicle] then
        musicData[currentVehicle].position = data.position
        TriggerServerEvent('qb-carmusic:server:seekMusic', currentVehicle, data.position)
    end
    cb('ok')
end)

RegisterNUICallback('getMusicInfo', function(data, cb)
    -- This would integrate with YouTube API for song info
    -- For now, return basic info
    cb({
        title = "Unknown",
        artist = "Unknown Artist",
        duration = 0,
        thumbnail = ""
    })
end)

-- Server events
RegisterNetEvent('qb-carmusic:client:syncMusic', function(musicInfo)
    -- Sync music from other players' vehicles
    if musicInfo.coords then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - musicInfo.coords)
        
        if distance <= Config.MaxDistance then
            SendNUIMessage({
                type = "playNearbyMusic",
                url = musicInfo.url,
                volume = musicInfo.volume,
                position = musicInfo.position,
                isPlaying = musicInfo.isPlaying
            })
        end
    end
end)

RegisterNetEvent('qb-carmusic:client:stopNearbyMusic', function(vehicleId)
    SendNUIMessage({
        type = "stopNearbyMusic",
        vehicleId = vehicleId
    })
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if isUIOpen then
            CloseUI()
        end
        
        -- Stop all music
        for vehicleId, _ in pairs(musicData) do
            TriggerServerEvent('qb-carmusic:server:stopMusic', vehicleId)
        end
    end
end)

-- Vehicle exit cleanup
AddEventHandler('baseevents:leftVehicle', function(vehicle, seat, displayName, netId)
    if seat == -1 and currentVehicle == vehicle then -- Driver seat
        if musicData[vehicle] and musicData[vehicle].isPlaying then
            TriggerServerEvent('qb-carmusic:server:stopMusic', vehicle)
        end
        currentVehicle = nil
        if isUIOpen then
            CloseUI()
        end
    end
end)