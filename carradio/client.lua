local QBCore = exports['qb-core']:GetCoreObject()
local isRadioOpen = false
local inVehicle = false
local isAuthorized = false

-- Function to check if player is in a vehicle
function IsInVehicle()
    local ped = PlayerPedId()
    return IsPedInAnyVehicle(ped, false)
end

-- Command to open the radio
RegisterCommand('carradio', function()
    if IsInVehicle() then
        isRadioOpen = not isRadioOpen
        SetNuiFocus(isRadioOpen, isRadioOpen)
        SendNUIMessage({ type = 'ui', status = isRadioOpen })
    else
        QBCore.Functions.Notify('You must be in a vehicle to use the car radio.', 'error')
    end
end, false)

-- Close UI with Escape key
RegisterKeyMapping('carradio', 'Close Car Radio', 'keyboard', 'ESCAPE')
AddEventHandler('carradio', function()
    if isRadioOpen then
        isRadioOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({ type = 'ui', status = false })
    end
end)

-- NUI Message Handler
RegisterNUICallback('close', function(_, cb)
    isRadioOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'ui', status = false })
    cb('ok')
end)

RegisterNUICallback('setRadioChannel', function(data, cb)
    if data.channel and data.channel > 0 then
        exports['pma-voice']:setVoiceProperty('radioChannel', tostring(data.channel))
    else
        exports['pma-voice']:setVoiceProperty('radioChannel', '0')
    end
    cb('ok')
end)

-- Check for vehicle status
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and not inVehicle then
            inVehicle = true
        elseif vehicle == 0 and inVehicle then
            inVehicle = false
            if isRadioOpen then
                isRadioOpen = false
                SetNuiFocus(false, false)
                SendNUIMessage({ type = 'ui', status = false })
                exports['pma-voice']:setVoiceProperty('radioChannel', '0')
            end
        end
    end
end)

-- Voice restriction
CreateThread(function()
    while true do
        Wait(500)
        if isRadioOpen then
            local radioChannel = exports['pma-voice']:getVoiceProperty('radioChannel')
            if radioChannel == '100.0' then
                QBCore.Functions.TriggerCallback('carradio:isPlayerAuthorized', function(authorized)
                    isAuthorized = authorized
                end)
                if not isAuthorized then
                    if IsControlPressed(0, 249) then -- Push to talk
                        QBCore.Functions.Notify("You are not authorized to speak on this frequency.", "error")
                        DisableControlAction(0, 249, true)
                    end
                end
            end
        end
    end
end)
