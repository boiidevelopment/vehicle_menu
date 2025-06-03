--- @section Variables

local vehicle_suspension_data = {}

--- @section Handlers

local HANDLERS <const> = {
    raise = function(vehicle)
        if not vehicle_suspension_data[vehicle] then
            get_original_suspension_height(vehicle)
        end
        local new_height = math.min(vehicle_suspension_data[vehicle].current_height - 0.02, 0.1)
        vehicle_suspension_data[vehicle].current_height = new_height
        SetVehicleSuspensionHeight(vehicle, new_height)
    end,

    lower = function(vehicle)
        if not vehicle_suspension_data[vehicle] then
            get_original_suspension_height(vehicle)
        end
        local new_height = math.max(vehicle_suspension_data[vehicle].current_height + 0.02, -0.1)
        vehicle_suspension_data[vehicle].current_height = new_height
        SetVehicleSuspensionHeight(vehicle, new_height)
    end,

    reset = function(vehicle)
        if vehicle_suspension_data[vehicle] then
            SetVehicleSuspensionHeight(vehicle, vehicle_suspension_data[vehicle].original_height or 0.0)
            vehicle_suspension_data[vehicle].current_height = vehicle_suspension_data[vehicle].original_height
        end
    end
}

--- @section Functions

--- Gets original vehicle suspension height.
--- @param vehicle: Vehicle to get suspension height for.
function get_original_suspension_height(vehicle)
    if not DoesEntityExist(vehicle) then return 0 end
    local current_height = GetVehicleSuspensionHeight(vehicle)
    if not vehicle_suspension_data[vehicle] then
        vehicle_suspension_data[vehicle] = { original_height = current_height, current_height = current_height }
    end
    return current_height
end

--- @section Events

--- Adjusts a vehicles suspension.
--- @param veh_netid: Vehicles NetID.
--- @param action string: Action handler to perform.
RegisterNetEvent('vehicle_menu:cl:adjust_suspension', function(veh_netid, action)
    local vehicle, player = NetworkGetEntityFromNetworkId(veh_netid), PlayerPedId()
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = true }
    if not DoesEntityExist(vehicle) or not trigger_vehicle_method('adjust_suspension', response) then return end
    if type(action) ~= "string" or not HANDLERS[action] then NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('handler_missing'), duration = 3000 }) return end
    HANDLERS[action](vehicle)
end)
