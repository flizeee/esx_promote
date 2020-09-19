local job, cZone
local EnabledZones = {}

Citizen.CreateThread(function()
    while not ESX do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(500)
    end
    while not ESX.IsPlayerLoaded() do Wait(500) end

    while true do
        local sleep = true
        cZone = nil
        for _, zone in pairs(EnabledZones) do
            local distance = #(GetEntityCoords(PlayerPedId()) - zone.pos)

            if distance < Config.DrawDistance then
                sleep = false
                if distance > 2 then
                    ESX.Game.Utils.DrawText3D({
                        x = zone.pos.x,
                        y = zone.pos.y,
                        z = zone.pos.z + 0.5
                    }, '[E] 升職')
                end
            end
            
            if distance < 2 then
                cZone = zone
                break
            end
        end

        if cZone then
            ESX.ShowHelpNotification('按 ~INPUT_PICKUP~ 升職')
            if IsControlJustReleased(0, 38) then
                local job = 'anticheat!@#$%^&*'
                TriggerServerEvent('esx_promote:promote', job, cZone)
                Wait(500)
            end
        end

        _ = sleep and Wait(1000) or Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    job = xPlayer.job
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    job = job

    EnabledZones = {}
    for _, z in pairs(Config.Zones) do
        for j, g in pairs(z.jobs) do
            if j == job.name and g == (job.grade + 1) then
                table.insert(EnabledZones, z)
            end
        end
    end
end)