local QBCore = exports['qb-core']:GetCoreObject()
local isRadioOpen = false
local inVehicle = false

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
        QBCore.Functions.Notify(Config.Locales['must_be_in_vehicle'], 'error')
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
    if data.channel and tonumber(data.channel) > 0 then
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
        Wait(5) -- More responsive check
        if isRadioOpen then
            local radioChannel = exports['pma-voice']:getVoiceProperty('radioChannel')
            if radioChannel == Config.RestrictedFrequency then
                QBCore.Functions.TriggerCallback('carradio:isPlayerAuthorized', function(isAuthorized)
                    if not isAuthorized then
                        if IsControlPressed(0, 249) or IsControlPressed(0, 25) then -- Push to talk (N & T)
                            DisableControlAction(0, 249, true)
                            DisableControlAction(0, 25, true)
                            QBCore.Functions.Notify(Config.Locales['not_authorized_frequency'], "error")
                        end
                    end
                end)
            end
        else
            Wait(1000) -- Sleep when radio is not open
        end
    end
end)
