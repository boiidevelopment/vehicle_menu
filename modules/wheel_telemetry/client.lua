--- @section Variables
local display_wheel_telemetry = false

--- Handles wheel telemetry data.
local function telemetry_wheel_display()
    while display_wheel_telemetry do
        Wait(100)
        local player = PlayerPedId()
        if IsPedInAnyVehicle(player, false) then
            local vehicle = GetVehiclePedIsIn(player, false)
            local num_wheels = GetVehicleNumberOfWheels(vehicle)
            local wheel_data = {}
            for i = 0, num_wheels - 1 do
                wheel_data[i + 1] = {
                    health = GetVehicleWheelHealth(vehicle, i),
                    power = GetVehicleWheelPower(vehicle, i),
                    speed = GetVehicleWheelSpeed(vehicle, i),
                    steering_angle = GetVehicleWheelSteeringAngle(vehicle, i),
                    suspension_compression = GetVehicleWheelSuspensionCompression(vehicle, i),
                    traction = GetVehicleWheelTractionVectorLength(vehicle, i)
                }
            end
            SendNUIMessage({ action = 'update_wheel_telemetry', wheels = wheel_data })
        else
            Wait(500)
        end
    end
end

--- Toggle telemetry UI.
local function toggle_wheel_telemetry()
    display_wheel_telemetry = not display_wheel_telemetry
    if not display_wheel_telemetry then
        SendNUIMessage({ action = 'toggle_wheel_telemetry' })
        CreateThread(telemetry_wheel_display)
        return
    end
    SendNUIMessage({ action = 'toggle_wheel_telemetry' })
end

--- @section Events

--- Handles toggling telemetry display.
RegisterNetEvent('vehicle_menu:cl:toggle_wheel_telemetry', function()
    local player, vehicle = PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false)
    local is_active = not display_wheel_telemetry
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = is_active }
    if not trigger_vehicle_method('toggle_wheel_telemetry', response) then return end
    display_wheel_telemetry = is_active
    SendNUIMessage({ action = 'toggle_wheel_telemetry', state = is_active })
    if is_active then 
        CreateThread(telemetry_wheel_display) 
    end
end)