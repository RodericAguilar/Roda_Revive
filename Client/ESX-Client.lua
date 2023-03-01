if GetResourceState('es_extended') == 'started' then 
    ESX = exports['es_extended']:getSharedObject()

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
        for k,v in pairs(Config.Points) do
            local dist = #(pedC - v.coords)
            if dist < 10 then
                wait = 0
                DrawMarker(2, vector3(v.coords.x, v.coords.y, v.coords.z + 0.2), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, -0.22, 220, 0, 0, 100, false, true, 2, true)
                if dist < 3 then
                    ESX.ShowFloatingHelpNotification('Press ~r~E~w~ to open the Revive Station.', vector3(v.coords.x, v.coords.y, v.coords.z + 0.50))
                    if dist < 2 then
                        if IsControlJustPressed(0, 38) then
                            if IsEntityDead(ped) then 
                                ESX.ShowNotification('You can\'t open the Revive Station while you are dead', 'error')
                            else
                                if not OpenStation() then
                                    ESX.ShowNotification('There is no dead players nearby', 'error', 3000)
                                end
                            end
                            
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
    end)
end