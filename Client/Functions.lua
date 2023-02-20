

function OpenStation()
   local mugs =  nearPlayersMug()
   local mugsEncode = json.encode(mugs)
   if mugsEncode == nil or mugsEncode == '[]' then 
        ESX.ShowNotification('There is no dead players nearby', 'error', 3000)
   else
        open = true
        SetNuiFocus(true, true)
        SetTimecycleModifier('hud_def_blur') -- blur
        for k,v in pairs(mugs) do 
            SendNUIMessage({
                action = 'openUI',
                name = v.name,
                img = v.pHeadshotTxd,
                pid = v.src
            })
        end
        return true
   end
end


local headsCache = {}
local maxDist = 3.0

function nearPlayersMug()
    -- clearHeadCache()

    local playerPos = GetEntityCoords(PlayerPedId())
    local player = PlayerId()

    local nearpl = {}
    for _,pl in ipairs(GetActivePlayers()) do
        if (pl ~= player) then
            local ped = GetPlayerPed(pl)

            if (DoesEntityExist(ped) and IsEntityVisible(ped)) and IsEntityDead(ped) then
                local pos = GetEntityCoords(ped)
                local distan = #(playerPos - pos)

                if (distan <= maxDist) then
                    local handle = RegisterPedheadshot(ped)    
                    local timer = 2000
                    while ((not handle or not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle)) and timer > 0) do
                        Wait(10)
                        timer = timer - 10
                    end

                    local txd = 'none'
                    if (IsPedheadshotReady(handle) and IsPedheadshotValid(handle)) then
                        table.insert(headsCache, handle)
                        txd = GetPedheadshotTxdString(handle)
                    end
                    
                    table.insert(nearpl, {
                        src = GetPlayerServerId(pl),
                        name = GetPlayerName(pl),
                        pHeadshotTxd = txd,
                        dist = distan
                    })
                end
            end
        end
    end

    if (#nearpl > 0) then
        table.sort(nearpl, function(a, b)
            return b.dist > a.dist
        end)
    end

    return nearpl
end

function clearHeadCache()
    for i = 0, #headsCache, 1 do
        UnregisterPedheadshot(headsCache[i])
    end

    headsCache = {}
end

