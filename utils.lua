--- @section Variables

saved_vehicle_data = {}
event_conditions = {}

--- @section Functions

--- Checks if a vehicle type is allowed.
--- @param vehicle number: The vehicle entity.
--- @return boolean: True if vehicle type is allowed, otherwise false.
function is_allowed_vehicle(vehicles, vehicle)
    local vehicle_type = GetVehicleClass(vehicle)
    for _, allowed in ipairs(vehicles) do
        if vehicle_type == allowed then return true end
    end
    return false
end

--- Determines if the current game build supports GetIsVehicleElectric.
--- @return boolean: True if the native is available, false otherwise.
function is_modern_game_build()
    return GetGameBuildNumber() >= 3258
end

--- Saves the vehicles original handling values before modifying.
--- @param vehicle number: The vehicle entity.
function save_vehicle_data(HANDLING_MODS, vehicle)
    if not DoesEntityExist(vehicle) or saved_vehicle_data[vehicle] then return end
    saved_vehicle_data[vehicle] = {}
    for _, mod in ipairs(HANDLING_MODS) do
        saved_vehicle_data[vehicle][mod[1]] = GetVehicleHandlingFloat(vehicle, 'CHandlingData', mod[1])
    end
end

--- Restores the vehicles original handling values.
--- @param vehicle number: The vehicle entity.
function restore_vehicle_data(vehicle)
    if not saved_vehicle_data[vehicle] then return end
    for key, value in pairs(saved_vehicle_data[vehicle]) do
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', key, value)
    end
    saved_vehicle_data[vehicle] = nil
end

--- Registers a method for a specific event.
--- @param event_name string: The event to method into.
--- @param callback function: The function to execute.
--- @param options table: Optional conditions for filtering.
--- @return number: The method ID.
function add_method(event_name, callback, options)
    if not event_conditions[event_name] then
        event_conditions[event_name] = {}
    end
    local id = #event_conditions[event_name] + 1
    event_conditions[event_name][id] = { callback = callback, options = options }
    return id
end

exports('add_method', add_method)

--- Triggers methods for an event, allowing methods to block or modify behavior.
--- @param event_name string: The event to trigger.
--- @param response table: Data sent to the method.
--- @return boolean: Returns false if any method blocks the action.
function trigger_vehicle_method(event_name, response)
    if not event_conditions[event_name] then return true end
    for _, method in pairs(event_conditions[event_name]) do
        local result = method.callback(response)
        if result == false then
            return false
        end
    end
    return true
end

--- Removes a registered method.
--- @param event_name string: The event to remove the method from.
--- @param id number: The ID of the method.
function remove_method(event_name, id)
    if event_conditions[event_name] then
        event_conditions[event_name][id] = nil
    end
end

exports('remove_method', remove_method)
