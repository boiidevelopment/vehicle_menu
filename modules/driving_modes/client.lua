--- @section Constants

local ALLOWED_VEHICLES = config.modes.driving_modes
local active_driving_modes = {}

--- @section Functions

--- Modifies a vehicle's handling for a driving mode.
--- @param vehicle number: Vehicle entity.
--- @param mode string: Driving mode key (comfort, eco, sport, track).
local function set_driving_mode(vehicle, mode)
    if not DoesEntityExist(vehicle) or not ALLOWED_VEHICLES[mode] or not is_allowed_vehicle(ALLOWED_VEHICLES[mode].allowed_vehicle_classes, vehicle) then return end
    local handling_mods = ALLOWED_VEHICLES[mode].handling_mods
    save_vehicle_data(handling_mods, vehicle)
    for _, mod in ipairs(handling_mods) do
        local current_value = GetVehicleHandlingFloat(vehicle, 'CHandlingData', mod[1])
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', mod[1], current_value + mod[2])
    end
end

--- Restores default vehicle handling.
--- @param vehicle number: Vehicle entity.
local function reset_driving_mode(vehicle)
    if not DoesEntityExist(vehicle) then return end
    restore_vehicle_data(vehicle)
end

--- Toggles driving mode for a vehicle.
--- @param vehicle number: Vehicle entity.
--- @param mode string: Driving mode key.
local function toggle_driving_mode(vehicle, mode)
    local veh_netid = NetworkGetNetworkIdFromEntity(vehicle)
    if active_driving_modes[veh_netid] == mode then
        reset_driving_mode(vehicle)
        active_driving_modes[veh_netid] = nil
        NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('driving_mode_disabled', string.upper(mode)), duration = 3000 })
    else
        restore_vehicle_data(vehicle)
        set_driving_mode(vehicle, mode)
        active_driving_modes[veh_netid] = mode
        NOTIFICATIONS.send({ type = 'success', header = L('notification_header'), message = L('driving_mode_enabled', string.upper(mode)), duration = 3000 })
    end
end

--- @section Events

--- Handles toggle driving mode.
RegisterNetEvent('vehicle_menu:cl:toggle_driving_mode', function(veh_netid, mode)
    local vehicle = NetworkGetEntityFromNetworkId(veh_netid)
    if DoesEntityExist(vehicle) and ALLOWED_VEHICLES[mode] then
        toggle_driving_mode(vehicle, mode)
    end
end)
