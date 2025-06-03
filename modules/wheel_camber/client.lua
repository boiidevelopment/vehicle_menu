--- @section Variables

local vehicle_wheel_camber_data = {}
local vehicle_wheel_toe_data = {}
local active_wheel_adjustments = false
local vehicles_with_adjustments = {}

--- @section Handlers

local CAMBER_HANDLERS = {
    outside = function(vehicle)
        get_original_wheel_data(vehicle)
        local num_wheels = GetVehicleNumberOfWheels(vehicle)
        for i = 0, num_wheels - 1 do
            local direction = i % 2 == 0 and 0.01 or -0.01
            vehicle_wheel_camber_data[vehicle][i].current_offset = vehicle_wheel_camber_data[vehicle][i].current_offset + direction
        end
        vehicles_with_adjustments[vehicle] = true
        update_wheel_thread()
    end,

    inside = function(vehicle)
        get_original_wheel_data(vehicle)
        local num_wheels = GetVehicleNumberOfWheels(vehicle)
        for i = 0, num_wheels - 1 do
            local direction = i % 2 == 0 and -0.01 or 0.01
            vehicle_wheel_camber_data[vehicle][i].current_offset = vehicle_wheel_camber_data[vehicle][i].current_offset + direction
        end
        vehicles_with_adjustments[vehicle] = true
        update_wheel_thread()
    end,

    reset = function(vehicle)
        if not vehicle_wheel_camber_data[vehicle] then return end
        local num_wheels = GetVehicleNumberOfWheels(vehicle)
        for i = 0, num_wheels - 1 do
            vehicle_wheel_camber_data[vehicle][i].current_offset = vehicle_wheel_camber_data[vehicle][i].original_offset
        end
        vehicles_with_adjustments[vehicle] = true
        update_wheel_thread()
    end
}

local TOE_HANDLERS = {
    top = function(vehicle)
        get_original_wheel_data(vehicle)
        local num_wheels = GetVehicleNumberOfWheels(vehicle)
        for i = 0, num_wheels - 1 do
            local direction = i % 2 == 0 and 0.05 or -0.05
            vehicle_wheel_toe_data[vehicle][i].current_rotation = vehicle_wheel_toe_data[vehicle][i].current_rotation + direction
        end
        vehicles_with_adjustments[vehicle] = true
        update_wheel_thread()
    end,

    bottom = function(vehicle)
        get_original_wheel_data(vehicle)
        local num_wheels = GetVehicleNumberOfWheels(vehicle)
        for i = 0, num_wheels - 1 do
            local direction = i % 2 == 0 and -0.05 or 0.05
            vehicle_wheel_toe_data[vehicle][i].current_rotation = vehicle_wheel_toe_data[vehicle][i].current_rotation + direction
        end
        vehicles_with_adjustments[vehicle] = true
        update_wheel_thread()
    end,

    reset = function(vehicle)
        if not vehicle_wheel_toe_data[vehicle] then return end
        local num_wheels = GetVehicleNumberOfWheels(vehicle)
        for i = 0, num_wheels - 1 do
            vehicle_wheel_toe_data[vehicle][i].current_rotation = vehicle_wheel_toe_data[vehicle][i].original_rotation
        end
        vehicles_with_adjustments[vehicle] = true
        update_wheel_thread()
    end
}

--- @section Functions

--- Gets original wheel data for vehicle.
--- @param vehicle: The current vehicle.
function get_original_wheel_data(vehicle)
    if not DoesEntityExist(vehicle) then return end
    if not vehicle_wheel_camber_data[vehicle] then vehicle_wheel_camber_data[vehicle] = {} end
    if not vehicle_wheel_toe_data[vehicle] then vehicle_wheel_toe_data[vehicle] = {} end
    local num_wheels = GetVehicleNumberOfWheels(vehicle)
    for i = 0, num_wheels - 1 do
        if not vehicle_wheel_camber_data[vehicle][i] then
            vehicle_wheel_camber_data[vehicle][i] = { original_offset = GetVehicleWheelXOffset(vehicle, i), current_offset = GetVehicleWheelXOffset(vehicle, i) }
        end
        if not vehicle_wheel_toe_data[vehicle][i] then
            vehicle_wheel_toe_data[vehicle][i] = { original_rotation = GetVehicleWheelYRotation(vehicle, i), current_rotation = GetVehicleWheelYRotation(vehicle, i) }
        end
    end
end

--- Handles wheel updates.
function update_wheel_thread()
    if active_wheel_adjustments then return end
    active_wheel_adjustments = true
    CreateThread(function()
        while next(vehicles_with_adjustments) do
            local updates = false
            for vehicle, _ in pairs(vehicles_with_adjustments) do
                if DoesEntityExist(vehicle) then
                    local num_wheels = GetVehicleNumberOfWheels(vehicle)
                    for i = 0, num_wheels - 1 do
                        if vehicle_wheel_camber_data[vehicle] and vehicle_wheel_camber_data[vehicle][i] then
                            SetVehicleWheelXOffset(vehicle, i, vehicle_wheel_camber_data[vehicle][i].current_offset)
                            updates = true
                        end
                        if vehicle_wheel_toe_data[vehicle] and vehicle_wheel_toe_data[vehicle][i] then
                            SetVehicleWheelYRotation(vehicle, i, vehicle_wheel_toe_data[vehicle][i].current_rotation)
                            updates = true
                        end
                    end
                else
                    vehicles_with_adjustments[vehicle] = nil
                end
            end
            Wait(updates and 0 or 500)
        end
        active_wheel_adjustments = false
    end)
end

--- @section Events

--- Handles synced camber adjustments.
--- @param veh_netid: Vehicles NetID.
--- @param action: Action handler to perform.
RegisterNetEvent('vehicle_menu:cl:adjust_camber', function(veh_netid, action)
    local vehicle, player = NetworkGetEntityFromNetworkId(veh_netid), PlayerPedId()
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = true }
    if not DoesEntityExist(vehicle) or not trigger_vehicle_method('adjust_camber', response) then return end
    if type(action) ~= "string" or not CAMBER_HANDLERS[action] then NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('handler_missing'), duration = 3000 }) return end
    CAMBER_HANDLERS[action](vehicle)
end)


--- Handles synced toe adjustments.
--- @param veh_netid: Vehicles NetID.
--- @param action: Action handler to perform.
RegisterNetEvent('vehicle_menu:cl:adjust_toe', function(veh_netid, action)
    local vehicle, player = NetworkGetEntityFromNetworkId(veh_netid), PlayerPedId()
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = true }
    if not DoesEntityExist(vehicle) or not trigger_vehicle_method('adjust_toe', response) then return end
    if type(action) ~= "string" or not TOE_HANDLERS[action] then NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('handler_missing'), duration = 3000 }) return end
    TOE_HANDLERS[action](vehicle)
end)