--- @section Variables

local active_autopilot = {}

--- @section Functions

--- Toggles Autopilot mode for a player.
--- @param source number: The players source ID.
local function toggle_autopilot(source)
    local player = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(source, { type = 'error', header = L('notification_header'),  message = L('not_in_vehicle'), duration = 3000 }) return end
    local is_active = not active_autopilot[source]
    active_autopilot[source] = is_active
    TriggerClientEvent('vehicle_menu:cl:toggle_autopilot', source, is_active)
end

--- @section Events

--- Handles toggling auto pilot.
RegisterServerEvent('vehicle_menu:sv:toggle_autopilot', function()
    local src = source
    toggle_autopilot(src)
end)