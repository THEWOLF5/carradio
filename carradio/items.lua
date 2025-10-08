local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem(Config.RadioItem, function(source, item)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return end

    TriggerClientEvent('carradio:use', source)
end)