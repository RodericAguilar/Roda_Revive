
RegisterServerEvent('Roda_Revive:server')
AddEventHandler('Roda_Revive:server', function (target)
    local src = source 
    local target = target
    local srcPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(target)
    local srcCoords = GetEntityCoords(srcPed)
    local targetCoords = GetEntityCoords(targetPed)
    local dist = #(srcCoords - targetCoords)
    if dist < 3 then 
        if GetResourceState('es_extended') == 'started' then 
            TriggerClientEvent('esx_ambulancejob:revive', target)
        else
            TriggerClientEvent("hospital:client:RevivePlayer", target)
        end
    else
        print('Possible hacker: ' .. source) -- Possible hacker
    end
end)