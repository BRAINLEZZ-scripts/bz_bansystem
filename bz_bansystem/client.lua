ESX = exports['es_extended']:getSharedObject()

-- Listen for a message to be shown when the player is banned
RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, true)
end)

-- Notify the player when they are banned
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('checkBanStatus')
end)

-- Display a custom ban message if they are banned (triggered by server-side event)
RegisterNetEvent('notifyBan')
AddEventHandler('notifyBan', function(banReason)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("You are banned from the server. Reason: " .. banReason)
    DrawNotification(false, true)
    -- Optional: Kick the player after notification
    Citizen.Wait(3000)  -- Wait for 3 seconds before kicking
    TriggerServerEvent('playerDisconnected')
    SetEntityHealth(PlayerPedId(), 0)  -- Kill the player (force disconnect)
end)