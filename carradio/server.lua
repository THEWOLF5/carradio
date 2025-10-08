local QBCore = exports['qb-core']:GetCoreObject()
local authorizedUsers = {}

RegisterCommand('grantradiofm', function(source, args, rawCommand)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player.PlayerData.job.name == 'police' and player.PlayerData.job.grade.level >= 4 then
        local targetId = tonumber(args[1])
        if targetId then
            local targetPlayer = QBCore.Functions.GetPlayer(targetId)
            if targetPlayer then
                local targetCitizenId = targetPlayer.PlayerData.citizenid
                if authorizedUsers[targetCitizenId] then
                    authorizedUsers[targetCitizenId] = nil
                    TriggerClientEvent('QBCore:Notify', src, 'You have revoked radio access for player ' .. targetId, 'error')
                    TriggerClientEvent('QBCore:Notify', targetId, 'Your radio access has been revoked.', 'error')
                else
                    authorizedUsers[targetCitizenId] = true
                    TriggerClientEvent('QBCore:Notify', src, 'You have granted radio access to player ' .. targetId, 'success')
                    TriggerClientEvent('QBCore:Notify', targetId, 'You have been granted radio access.', 'success')
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'Player not found.', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Invalid player ID.', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are not authorized to use this command.', 'error')
    end
end, true)

QBCore.Functions.CreateCallback('carradio:isPlayerAuthorized', function(source, cb)
    local player = QBCore.Functions.GetPlayer(source)
    if player then
        cb(authorizedUsers[player.PlayerData.citizenid] or false)
    else
        cb(false)
    end
end)
