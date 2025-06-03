--- @section Variables

local active_tank_turns = {}

--- @section Functions

--- Toggles Tank Turn mode for a vehicle.
--- @param source number: The players source ID.
local function toggle_tank_turn(source, direction)
    local player = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(source, { type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    local veh_netid = NetworkGetNetworkIdFromEntity(vehicle)
    local is_active = not active_tank_turns[veh_netid]
    active_tank_turns[veh_netid] = is_active
    TriggerClientEvent('vehicle_menu:cl:toggle_tank_turn', source, veh_netid, is_active, direction)
end

--- @section Events

--- Handles tank turns.
RegisterServerEvent('vehicle_menu:sv:toggle_tank_turn', function(direction)
    local src = source
    local direction = direction == 'right' and 'right' or 'left'
    toggle_tank_turn(src, direction)
end)
