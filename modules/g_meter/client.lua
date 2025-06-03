--- @section Variables

local g_meter_active = false

--- @section Functions

--- Handles gmeter display.
local function g_meter_display()
    local last_velocity = vector3(0, 0, 0)
    local last_time = GetGameTimer()
    while g_meter_active do
        Wait(50)
        local player = PlayerPedId()
        if IsPedInAnyVehicle(player, false) then
            local vehicle = GetVehiclePedIsIn(player, false)
            local current_velocity = GetEntityVelocity(vehicle)
            local dt = (GetGameTimer() - last_time) / 1000
            local acceleration = (current_velocity - last_velocity) / dt
            local lateral_g = acceleration.y / 9.81
            local longitudinal_g = acceleration.x / 9.81
            SendNUIMessage({ action = 'update_g_meter', accel = math.max(0, longitudinal_g), brake = math.abs(math.min(0, longitudinal_g)), left = math.max(0, lateral_g), right = math.abs(math.min(0, lateral_g))})
            last_velocity = current_velocity
            last_time = GetGameTimer()
        else
            Wait(1000)
        end
    end
end

--- Toggles g meter.
local function toggle_g_meter()
    g_meter_active = not g_meter_active
    if g_meter_active then
        CreateThread(g_meter_display)
        SendNUIMessage({ action = 'toggle_g_meter' })
    else
        SendNUIMessage({ action = 'toggle_g_meter' })
    end
end

--- @section Events

--- Handles toggling g meter ui.
RegisterNetEvent('vehicle_menu:cl:toggle_g_meter', function()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    local is_active = not g_meter_active
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = is_active }
    if not trigger_vehicle_method('toggle_g_meter', response) then return end
    toggle_g_meter()
end)
