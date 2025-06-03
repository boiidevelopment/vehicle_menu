--- @section Events

--- Toggles camber synced.
--- @param action string: Action handler to perform.
RegisterServerEvent('vehicle_menu:sv:toggle_camber')
AddEventHandler('vehicle_menu:sv:toggle_camber', function(action)
    local src = source
    local player = GetPlayerPed(src)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(src, { type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    TriggerClientEvent('vehicle_menu:cl:adjust_camber', -1, NetworkGetNetworkIdFromEntity(vehicle), action)
end)

--- Toggles toe synced.
--- @param action string: Action handler to perform.
RegisterServerEvent('vehicle_menu:sv:toggle_toe')
AddEventHandler('vehicle_menu:sv:toggle_toe', function(action)
    local src = source
    local player = GetPlayerPed(src)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(src, { type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    TriggerClientEvent('vehicle_menu:cl:adjust_toe', -1, NetworkGetNetworkIdFromEntity(vehicle), action)
end)