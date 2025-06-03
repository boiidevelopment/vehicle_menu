--- @section Variables
local active_driving_modes = {}

--- @section Functions

--- Toggles a driving mode for a vehicle.
--- @param source number: The players source ID.
--- @param mode string: Driving mode key (eco, sport, comfort, track, drift).
local function toggle_driving_mode(source, mode)
    local player = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(player, false)
    if not vehicle or vehicle == 0 then NOTIFICATIONS.send(source, { type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    local veh_netid = NetworkGetNetworkIdFromEntity(vehicle)
    if active_driving_modes[veh_netid] == mode then
        TriggerClientEvent('vehicle_menu:cl:toggle_driving_mode', source, veh_netid, nil)
        active_driving_modes[veh_netid] = nil
        NOTIFICATIONS.send(source, { type = 'info', header = L('notification_header'), message = L('driving_mode_disabled', string.upper(mode)), duration = 3000 })
        return
    end
    TriggerClientEvent('vehicle_menu:cl:toggle_driving_mode', source, veh_netid, mode)
    active_driving_modes[veh_netid] = mode
end

--- @section Events

--- Handled toggling driving modes.
RegisterServerEvent('vehicle_menu:sv:toggle_driving_mode')
AddEventHandler('vehicle_menu:sv:toggle_driving_mode', function(mode)
    local src = source
    if not config.modes.driving_modes[mode] then NOTIFICATIONS.send(src, { type = 'error', header = L('notification_header'), message = L('invalid_driving_mode'), duration = 3000 }) return end
    toggle_driving_mode(src, mode)
end)