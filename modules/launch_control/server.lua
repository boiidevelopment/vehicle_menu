--- @section Functions

--- Toggles Launch Control Mode for a vehicle.
--- @param source number: The players source ID.
local function activate_launch_control(source)
    local player = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(source, { type = 'error', header = L('notification_header'),  message = L('not_in_vehicle'), duration = 3000 }) return end
    local veh_netid = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerClientEvent('vehicle_menu:cl:activate_launch_control', source, veh_netid)
end

--- @section Events

--- Handles toggling Launch Control.
RegisterServerEvent('vehicle_menu:sv:activate_launch_control', function()
    local src = source
    activate_launch_control(src)
end)