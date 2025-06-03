--- @section Events

--- Handles toggling suspension synced.
--- @param action string: Action handler to perform.
RegisterServerEvent('vehicle_menu:sv:toggle_suspension')
AddEventHandler('vehicle_menu:sv:toggle_suspension', function(action)
    local src = source
    local player = GetPlayerPed(src)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(src, { type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    local veh_netid = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerClientEvent('vehicle_menu:cl:adjust_suspension', -1, veh_netid, action)
end)
