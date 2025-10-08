local QBCore = exports['qb-core']:GetCoreObject()
local isRadioOpen = false
local currentVehicle = nil
local currentSound = nil

-- Function to toggle the radio UI
local function toggleRadioUI(status)
    isRadioOpen = status
    SetNuiFocus(isRadioOpen, isRadioOpen)
    SendNUIMessage({ type = 'ui', status = isRadioOpen })

    if isRadioOpen then
        SendNUIMessage({
            type = 'setup',
            logo = Config.ServerLogo,
            stations = Config.Stations
        })
    end
end

-- Event to use the radio item
RegisterNetEvent('carradio:use', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        QBCore.Functions.Notify("You must be in a vehicle to use the radio.", "error")
        return
    end

    currentVehicle = vehicle
    toggleRadioUI(not isRadioOpen)
end)

-- NUI Callback for closing the UI (X button)
RegisterNUICallback('close', function(_, cb)
    toggleRadioUI(false)
    cb('ok')
end)

-- NUI Callback for playing a station
RegisterNUICallback('play', function(data, cb)
    if not currentVehicle or not DoesEntityExist(currentVehicle) then return end

    local vehicleNetId = VehToNet(currentVehicle)
    TriggerServerEvent('carradio:sync', vehicleNetId, data.station, 0.5)
    cb('ok')
end)

-- NUI Callback for adjusting volume
RegisterNUICallback('volume', function(data, cb)
    if not currentVehicle or not DoesEntityExist(currentVehicle) then return end

    local vehicleNetId = VehToNet(currentVehicle)
    TriggerServerEvent('carradio:syncVolume', vehicleNetId, data.volume)
    cb('ok')
end)

-- Event to sync radio state from server
RegisterNetEvent('carradio:playClient', function(vehicleNetId, url, volume)
    local vehicle = NetToVeh(vehicleNetId)
    if not vehicle or not DoesEntityExist(vehicle) then return end

    local soundId = "carradio_" .. vehicleNetId

    exports.xsound:destroy(soundId)
    exports.xsound:playUrl(soundId, url, volume, false)
    exports.xsound:attachToEntity(soundId, vehicle)
    currentSound = soundId
end)

-- Event to sync volume state from server
RegisterNetEvent('carradio:syncVolumeClient', function(vehicleNetId, volume)
    local soundId = "carradio_" .. vehicleNetId
    exports.xsound:setVolume(soundId, volume)
end)

-- Event to stop radio on client
RegisterNetEvent('carradio:stopClient', function(vehicleNetId)
    local soundId = "carradio_" .. vehicleNetId
    exports.xsound:destroy(soundId)
    if currentSound == soundId then
        currentSound = nil
    end
end)

-- Thread to monitor player's vehicle status
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if currentVehicle and vehicle ~= currentVehicle then
            if isRadioOpen then
                toggleRadioUI(false)
            end
            local vehicleNetId = VehToNet(currentVehicle)
            TriggerServerEvent('carradio:playerLeft', vehicleNetId)
            currentVehicle = nil
            currentSound = nil
        end
    end
end)