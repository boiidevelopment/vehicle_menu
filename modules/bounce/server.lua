--- @section Variables

local active_bounce_modes = {}

--- @section Functions

--- Toggles bounce mode.
--- @param source number: Players source id.
local function toggle_bounce(source)
    local player = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(source, { type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    local veh_netid = NetworkGetNetworkIdFromEntity(vehicle)
    local is_active = not active_bounce_modes[veh_netid]
    active_bounce_modes[veh_netid] = is_active
    TriggerClientEvent('vehicle_menu:cl:toggle_bounce', -1, veh_netid, is_active)
end

--- @section Events

--- Handles toggle bounce.
RegisterServerEvent('vehicle_menu:sv:toggle_bounce', function()
    toggle_bounce(source)
end)
