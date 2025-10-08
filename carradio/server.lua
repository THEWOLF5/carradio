local QBCore = exports['qb-core']:GetCoreObject()
local authorizedUsers = {}

RegisterCommand('grantradiofm', function(source, args, rawCommand)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if player.PlayerData.job.name == Config.AuthorizedJob and player.PlayerData.job.grade.level >= Config.RequiredGrade then
        local targetId = tonumber(args[1])
        if targetId then
            local targetPlayer = QBCore.Functions.GetPlayer(targetId)
            if targetPlayer then
                local targetCitizenId = targetPlayer.PlayerData.citizenid
                if authorizedUsers[targetCitizenId] then
                    authorizedUsers[targetCitizenId] = nil
                    TriggerClientEvent('QBCore:Notify', src, string.format(Config.Locales['access_revoked'], targetId), 'error')
                    TriggerClientEvent('QBCore:Notify', targetId, Config.Locales['your_access_revoked'], 'error')
                else
                    authorizedUsers[targetCitizenId] = true
                    TriggerClientEvent('QBCore:Notify', src, string.format(Config.Locales['access_granted'], targetId), 'success')
                    TriggerClientEvent('QBCore:Notify', targetId, Config.Locales['your_access_granted'], 'success')
                end
            else
                TriggerClientEvent('QBCore:Notify', src, Config.Locales['player_not_found'], 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Locales['invalid_player_id'], 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Locales['not_authorized_command'], 'error')
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
