TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_promote:promote')
AddEventHandler('esx_promote:promote', function(ac, zone)
    if ac ~= 'anticheat!@#$%^&*' then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and ESX.DoesJobExist(xPlayer.job.name, xPlayer.job.grade+1) then
        for i, c in pairs(zone.reqiures) do
            local xItem = xPlayer.getInventoryItem(i)
            if xItem.count < c then
                return xPlayer.showNotification(('你需要 ~b~%sx %s ~w~來升職'):format(c, xItem.label))
            end
        end

        for i, c in pairs(zone.reqiures) do
            xPlayer.removeInventoryItem(i, c)
        end

        xPlayer.setJob(xPlayer.job.name, xPlayer.job.grade+1)
        xPlayer.showNotification('你已升職為~g~' .. xPlayer.getJob().grade_label)
    end
end)