--- @section Constants

local ALLOWED_VEHICLES <const> = config.modes.launch_control.allowed_vehicle_classes or {}
local RPM_LIMIT <const> = config.modes.launch_control.rpm_limit or 4500
local THROTTLE_HOLD_TIME <const> = config.modes.launch_control.launch_prime_time or 3000
local HANDLING_MODS <const> = config.modes.launch_control.handling_mods or {}
local LAUNCH_KEY <const> = config.modes.launch_control.launch_key

--- @section Variables

local launch_control_active = false
local launch_control_primed = false

--- @section Functions

--- Applies handling modifications for launch control.
--- @param vehicle number: The vehicle entity.
local function apply_launch_handling(vehicle)
    for _, mod in ipairs(HANDLING_MODS) do
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', mod[1], mod[2])
    end
end

--- Executes the launch when SPACEBAR is pressed.
--- @param vehicle number: The vehicle entity.
local function execute_launch(vehicle)
    launch_control_active = false
    launch_control_primed = false
    SetVehicleHandbrake(vehicle, false)
    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('launch_engaged'), duration = 2000 })
    Wait(2000)
    restore_vehicle_data(vehicle)
end

--- Activates launch control mode.
--- @param vehicle number: The vehicle entity.
local function activate_launch_control(vehicle)
    if not DoesEntityExist(vehicle) or not is_allowed_vehicle(ALLOWED_VEHICLES, vehicle) then return end
    if launch_control_active then return end
    launch_control_active = true
    launch_control_primed = false
    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('prime_launch'), duration = 2000 })
    save_vehicle_data(HANDLING_MODS, vehicle)
    apply_launch_handling(vehicle)
    SetVehicleHandbrake(vehicle, true)
    SetVehicleCurrentRpm(vehicle, RPM_LIMIT / 6500.0)
    CreateThread(function()
        local start_time
        while launch_control_active do
            Wait(0)
            if IsControlPressed(0, KEY_LIST['w']) then
                if not start_time then start_time = GetGameTimer() end
                if GetGameTimer() - start_time >= THROTTLE_HOLD_TIME then
                    launch_control_primed = true
                    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('launch_primed', string.upper(LAUNCH_KEY)), duration = 2000 })
                    break
                end
            else
                start_time = nil
            end
        end
    end)
    CreateThread(function()
        while launch_control_active do
            Wait(0)
            if launch_control_primed and IsControlJustPressed(0, KEY_LIST[LAUNCH_KEY]) then
                execute_launch(vehicle)
                break
            end
        end
    end)
end

--- @section Events

--- Event to toggle launch control.
RegisterNetEvent('vehicle_menu:cl:activate_launch_control', function()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    local is_active = not LAUNCH_CONTROL_ACTIVE
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = is_active }
    if not trigger_vehicle_method('activate_launch_control', response) then return end
    activate_launch_control(vehicle)
end)