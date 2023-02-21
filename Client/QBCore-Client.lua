if GetResourceState('qb-core') == 'started' then 
    local QBCore = exports['qb-core']:GetCoreObject()

    RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
    SetTimecycleModifier('default')
    end)

    RegisterNUICallback('revive', function(data, cb)
    local playerId = tonumber(data.src)
    TriggerServerEvent('Roda_Revive:server', playerId)
    end)

    CreateThread(function()
    while true do
        local wait = 500

        local ped = PlayerPedId()
        local pedC = GetEntityCoords(ped)
        local inZone = false
        for k,v in pairs(Config.Points) do
            local dist = #(pedC - v.coords)
            if dist < 10 then
                wait = 0
                DrawMarker(2, vector3(v.coords.x, v.coords.y, v.coords.z + 0.2), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, -0.22, 220, 0, 0, 100, false, true, 2, true)
                if dist < 3 then
                    if not inZone then
                        local inZone = true
                        TriggerEvent('qb-core:client:DrawText', "Press ~r~E~w~ to open the Revive Station.", 'right')
                    end
                    if dist < 2 then
                        if IsControlJustPressed(0, 38) then
                            if IsEntityDead(ped) then 
                                QBCore.Functions.Notify('You can\'t open the Revive Station while you are dead', 'error', 3000)
                            else
                                if not OpenStation() then
                                    QBCore.Functions.Notify('There is no dead players nearby', 'error', 3000)
                                end
                            end
                            
                        end
                    end
                else
                    inZone = false
                    TriggerEvent('qb-core:client:HideText')
                end
            end
        end
        Wait(wait)
    end
    end)
end