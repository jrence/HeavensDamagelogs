local parts = {
    ['eyebrow'] = 1356,
    ['left toe'] = 2108,
    ['right elbow'] = 2992,
    ['left arm'] = 5232,
    ['right hand'] = 6286,
    ['right thigh'] = 6442,
    ['right collarbone'] = 10706,
    ['right corner of the mouth'] = 11174,
    ['sinks'] = 11816,
    ['head'] = 12844,
    ['left foot'] = 14201,
    ['right knee'] = 16335,
    ['lower lip'] = 17188,
    ['lip'] = 17719,
    ['left hand'] = 18905,
    ['right cheekbone'] = 19336,
    ['right toe'] = 20781,
    ['nerve of the lower lip'] = 20279,
    ['left cheekbone'] = 21550,
    ['left elbow'] = 22711,
    ['spinal root'] = 23553,
    ['left thigh'] = 23639,
    ['right foot'] = 24806,
    ['lower part of the spine'] = 24816,
    ['the middle part of the spine'] = 24817,
    ['the upper part of the spine'] = 24818,
    ['left eye'] = 25260,
    ['right eye'] = 27474,
    ['right arm'] = 28252,
    ['left corner of the mouth'] = 29868,
    ['neck'] = 35731,
    ['right calf'] = 36864,
    ['right forearm'] = 43810,
    ['left shoulder'] = 45509,
    ['left knee'] = 46078,
    ['jaw'] = 46240,
    ['tongue'] = 47495,
    ['nerve of the upper lip'] = 49979,
    ['right thigh'] = 51826,
    ['root'] = 56604,
    ['spine'] = 57597,
    ['left foot bone'] = 57717,
    ['left eyebrow'] = 58331,
    ['left hand bone'] = 60309,
    ['left forearm'] = 61163,
    ['upper lip'] = 61839,
    ['left calf'] = 63931,
    ['left collarbone'] = 64729,
    ['face'] = 65068
}

local lastBone = nil
Citizen.CreateThread(function()
    while true do
        local idle = 2000
        local foundLastDamagedBone, lastDamagedBone = GetPedLastDamageBone(PlayerPedId())
        if foundLastDamagedBone and lastDamagedBone ~= lastBone then
            local damagedBone = GetKeyOfValue(parts, lastDamagedBone)
            if damagedBone then
                local remainingHP = GetEntityHealth(PlayerPedId()) - 100
                local remainingAR = GetPedArmour(PlayerPedId())
                local message = string.format("%s [Damage Area] %s [Remaining HP] %d [Remaining Armor] %d", GetPlayerName(PlayerId()), damagedBone, remainingHP, remainingAR)
                TriggerServerEvent('asd', message)
                lastBone = lastDamagedBone
                idle = 0
            end
        end
        Citizen.Wait(idle)
    end
end)

function GetKeyOfValue(table, searchedFor)
    for key, value in pairs(table) do
        if searchedFor == value then
            return key
        end
    end
    return nil
end

local function drawTxt(x, y, scale, text, r, g, b, font, centered)
    SetTextFont(font or 4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    if centered then
        SetTextCentre(true)
    end
    SetTextColour(r, g, b, 255)
    SetTextDropShadow(0, 0, 0, 0, 150)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local damageLog = {}
local maxDamageLogs = 5

RegisterNetEvent("damagelogs")
AddEventHandler("damagelogs", function(damageAmount, senderId, isDead)
    local damageText = isDead and string.format("DEAD(%d)", math.min(damageAmount, 200)) or math.min(damageAmount, 200)
    table.insert(damageLog, {timestamp = GetGameTimer() + 500, totalDamage = damageText})
    if #damageLog > maxDamageLogs then
        table.remove(damageLog, 1)
    end
    TriggerServerEvent('totaldamage', damageText)
end)

Citizen.CreateThread(function()
    while true do
        local idle = 2000
        if #damageLog > 0 then
            local posY = 0.50
            for _, v in ipairs(damageLog) do
                if GetGameTimer() < v.timestamp then
                    drawTxt(0.53, posY, 0.6, tostring(v.totalDamage), 252, 78, 66, 2, 1)
                    posY = posY - 0.025
                    idle = 0
                else
                    table.remove(damageLog, 1)
                end
            end
        end
        Citizen.Wait(idle)
    end
end)
