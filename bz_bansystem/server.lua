ESX = exports['es_extended']:getSharedObject()


-- Ban Command
RegisterCommand('bzban', function(source, args, rawCommand)
    local _source = source
    local targetPlayer = tonumber(args[1]) -- Get player ID
    local reason = table.concat(args, " ", 2) -- Get the reason

    if not targetPlayer or not reason or reason == "" then
        TriggerClientEvent('chat:addMessage', _source, {
            args = { "^1ERROR", "Usage: /ban [player_id] [reason]" }
        })
        return
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getGroup() ~= 'admin' then
        TriggerClientEvent('chat:addMessage', _source, {
            args = { "^1ERROR", "You do not have permission to use this command!" }
        })
        return
    end

    local targetIdentifier = GetPlayerIdentifier(targetPlayer, 0) -- Get Steam ID

    if not targetIdentifier then
        TriggerClientEvent('chat:addMessage', _source, {
            args = { "^1ERROR", "Invalid player ID!" }
        })
        return
    end

    -- Ban the player and insert into database
    MySQL.insert('INSERT INTO bans (player_identifier, ban_reason, banned_by) VALUES (?, ?, ?)', {
        targetIdentifier, reason, xPlayer.getName()
    }, function()
        DropPlayer(targetPlayer, "You have been banned for: " .. reason)
        TriggerClientEvent('chat:addMessage', _source, {
            args = { "^2SUCCESS", "Player has been banned successfully!" }
        })
    end)
end, false)

-- Check if player is banned on connection
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local _source = source
    local playerIdentifier = GetPlayerIdentifier(_source, 0) -- Get Steam ID

    deferrals.defer() -- Pause connection to check database
    Wait(100) -- Short delay to prevent issues

    MySQL.query('SELECT * FROM bans WHERE player_identifier = ?', {playerIdentifier}, function(result)
        if result[1] then
            deferrals.done("You are banned from this server. Reason: " .. result[1].ban_reason)

            -- Notify the banned player through client event
            TriggerClientEvent('notifyBan', _source, result[1].ban_reason)
        else
            deferrals.done() -- Allow connection
        end
    end)
end)