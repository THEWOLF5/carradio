local QBCore = exports['qb-core']:GetCoreObject()

-- Table to store the radio state for each vehicle
-- Key: vehicleNetId, Value: {url = "...", volume = 0.5}
local vehicleRadios = {}

-- Event handler for syncing and starting the radio
RegisterNetEvent('carradio:sync', function(vehicleNetId, url, volume)
    local source = source
    if not vehicleNetId or not url or not volume then return end

    -- Store the state
    vehicleRadios[vehicleNetId] = {
        url = url,
        volume = volume
    }

    -- Notify all clients to play the sound for this vehicle
    TriggerClientEvent('carradio:playClient', -1, vehicleNetId, url, volume)
end)

-- Event handler for syncing volume changes
RegisterNetEvent('carradio:syncVolume', function(vehicleNetId, volume)
    if not vehicleNetId or not volume then return end
    if not vehicleRadios[vehicleNetId] then return end

    -- Update the volume
    vehicleRadios[vehicleNetId].volume = volume

    -- Notify all clients of the volume change
    TriggerClientEvent('carradio:syncVolumeClient', -1, vehicleNetId, volume)
end)

-- When a player enters a vehicle, check if it's already playing music
AddEventHandler('playerEnteredVehicle', function(player, vehicle, seat)
    local vehicleNetId = VehToNet(vehicle)
    if not vehicleNetId then return end

    -- Check if this vehicle has a radio state
    local radioState = vehicleRadios[vehicleNetId]
    if radioState then
        -- If so, tell the entering player's client to start playing the music
        TriggerClientEvent('carradio:playClient', player, vehicleNetId, radioState.url, radioState.volume)
    end
end)

-- Cleanup thread to remove data for non-existent vehicles
CreateThread(function()
    while true do
        Wait(60000) -- Run every minute
        for vehicleNetId, _ in pairs(vehicleRadios) do
            if not NetworkDoesNetworkIdExist(vehicleNetId) then
                vehicleRadios[vehicleNetId] = nil
                -- Tell clients to stop the sound just in case
                TriggerClientEvent('carradio:stopClient', -1, vehicleNetId)
            end
        end
    end
end)

-- When a player leaves the server, we might want to check if they were the last one in a vehicle
-- For now, we let the radio play as it's tied to the vehicle, not the player.
-- The cleanup thread will handle orphaned vehicle data.