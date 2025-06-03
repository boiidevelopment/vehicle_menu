--- @section Functions

--- Toggles Donut Mode for a vehicle.
--- @param source number: The players source ID.
local function start_donut(source)
    local player = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(source, { type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    local veh_netid = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerClientEvent('vehicle_menu:cl:toggle_donuts', source, veh_netid)
end

--- @section Events

--- Handles toggling donuts.
RegisterServerEvent('vehicle_menu:sv:toggle_donuts', function()
    local src = source
    start_donut(src)
end)