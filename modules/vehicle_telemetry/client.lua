--- @section Variables
local display_vehicle_telemetry = false

--- @section Functions

--- Gathers vehicle telemetry data.
--- @param vehicle number: The vehicle entity.
--- @return table: The telemetry data.
local function get_vehicle_telemetry(vehicle)
    return {
        body_health = GetVehicleBodyHealth(vehicle),
        engine_health = GetVehicleEngineHealth(vehicle),
        engine_temperature = GetVehicleEngineTemperature(vehicle),
        fuel_level = GetVehicleFuelLevel(vehicle),
        oil_level = GetVehicleOilLevel(vehicle),
        oil_temp = GetVehicleDashboardOilTemp(),
        oil_pressure = GetVehicleDashboardOilPressure(),
        coolant_temp = GetVehicleDashboardTemp(),
        vacuum_pressure = GetVehicleDashboardVacuum(),
        turbo_pressure = GetVehicleTurboPressure(vehicle),
        dashboard_fuel = GetVehicleDashboardFuel()
    }
end

--- Monitors and sends vehicle telemetry data.
local function telemetry_vehicle_display()
    while display_vehicle_telemetry do
        Wait(100)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(vehicle) then
            SendNUIMessage({ action = 'update_vehicle_telemetry', data = get_vehicle_telemetry(vehicle) })
        else
            Wait(500)
        end
    end
end

--- Toggles vehicle telemetry monitoring.
RegisterNetEvent('vehicle_menu:cl:toggle_vehicle_telemetry', function()
    local player, vehicle = PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false)
    local is_active = not display_vehicle_telemetry
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = is_active }
    if not trigger_vehicle_method('toggle_vehicle_telemetry', response) then return end
    display_vehicle_telemetry = is_active
    SendNUIMessage({ action = 'toggle_vehicle_telemetry' })
    if is_active then
        CreateThread(telemetry_vehicle_display)
    end
end)

--- @section Commands

RegisterCommand('toggle_vehicle_telemetry', function()
    TriggerEvent('vehicle_menu:cl:toggle_vehicle_telemetry')
    print('Vehicle telemetry display is now ' .. (display_vehicle_telemetry and 'enabled' or 'disabled'))
end, false)
