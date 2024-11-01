local webhook = "Webhook" -- Define your webhook URL here
local webhook2 = "Webhook" -- Define your webhook URL here2
local discordLogImage = "https://cdn.discordapp.com/attachments/873184959400149072/890646026044731412/dollar-black-poster.png"

--current todo is fetch player ip but not in plan because of TOS on my country privacy breach and steam maybe---

RegisterServerEvent('damagebone')
AddEventHandler('damagebone', function(damage)
    logDamage(source, damage)
end)

RegisterServerEvent('totaldamage')
AddEventHandler('totaldamage', function(damage1)
    logTotalDamage(source, damage1)
end)

function extractIdentifiers(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    local identifierData = {
        steam = "N/A",
        license = "N/A",
        discord = "N/A",
        xbl = "N/A",
        live = "N/A",
        ip = "N/A"
    }

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "steam:") then
            identifierData.steam = identifier
        elseif string.find(identifier, "license:") then
            identifierData.license = identifier
        elseif string.find(identifier, "discord:") then
            identifierData.discord = identifier
        elseif string.find(identifier, "xbl:") then
            identifierData.xbl = identifier
        elseif string.find(identifier, "live:") then
            identifierData.live = identifier
        elseif string.find(identifier, "ip:") then
            identifierData.ip = string.sub(identifier, 4) -- Remove the "ip:" prefix
        end
    end
    
    return identifierData
end

function createLogEmbed(title, description)
    return {
        color = "66666",
        author = {
            name = "Damage Logs!",
            icon_url = discordLogImage
        },
        type = "rich",
        title = title,
        description = description,
        footer = {
            text = "Damage Logs!!  |  " .. os.date("%m/%d/%Y")
        }
    }
end

function sendWebhook(webhookUrl, logInfo)
    PerformHttpRequest(webhookUrl, function(err, text, headers)
        if err then
            print("[Damage logs] Error sending message to webhook: " .. err)
        end
    end, "POST", json.encode({username = "Heavens!", avatar_url = avatar_url, embeds = {logInfo}}), { ["Content-Type"] = "application/json" })
end

function logDamage(playerId, damage)
    local identifiers = extractIdentifiers(playerId)
    local description = damage .. "\n **IP : **" .. identifiers.ip .. "\n **SteamID: **" .. identifiers.steam .. "\n **License: **" .. identifiers.license .. "\n **Discord: **" .. identifiers.discord .. "\n **XBL: **" .. identifiers.xbl .. "\n **Live: **" .. identifiers.live
    local logInfo = createLogEmbed("Damage Logs", description)
    sendWebhook(webhook, logInfo)
end

function logTotalDamage(playerId, damage1)
    local identifiers = extractIdentifiers(playerId)
    local description = damage1 .. "\n **IP : **" .. identifiers.ip .. "\n **SteamID: **" .. identifiers.steam .. "\n **License: **" .. identifiers.license .. "\n **Discord: **" .. identifiers.discord .. "\n **XBL: **" .. identifiers.xbl .. "\n **Live: **" .. identifiers.live
    local logInfo = createLogEmbed("Total Damage Logs", description)
    sendWebhook(webhook2, logInfo)
end

AddEventHandler('weaponDamageEvent', function(sender, data)
    local damage = data.weaponDamage
    local isKill = data.willKill
    TriggerClientEvent('damagelogs', sender, data.weaponDamage, sender, isKill)
end)
