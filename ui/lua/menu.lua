--- @section Constants

local MENU_KEY <const> = config.menu_toggle_key

--- @section Variables

local has_nui_focus = false
local window_states = { false, false, false, false }

--- @section Local functions

--- Toggle engine state based on its current state.
local function toggle_engine()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 or not DoesEntityExist(vehicle) then NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 }) return end
    local state = GetIsVehicleEngineRunning(vehicle)
    SetVehicleEngineOn(vehicle, not state, false, true)
    local message = state and 'engine_stopped' or 'engine_started'
    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L(message), duration = 3000 })
end

--- Toggle vehicle doors
--- @param vehicle: The vehicle to toggle doors for.
--- @param door_index: The door to toggle.
local function toggle_door(vehicle, door_index)
    if door_index == -1 then
        local open_any = false
        for i = 0, 5 do
            if GetVehicleDoorAngleRatio(vehicle, i) > 0.0 then
                open_any = true
                break
            end
        end
        for i = 0, 5 do
            if open_any then
                SetVehicleDoorShut(vehicle, i, false)
            else
                SetVehicleDoorOpen(vehicle, i, false, false)
            end
        end
    else
        if GetVehicleDoorAngleRatio(vehicle, door_index) > 0.0 then
            SetVehicleDoorShut(vehicle, door_index, false)
        else
            SetVehicleDoorOpen(vehicle, door_index, false, false)
        end
    end
end

--- @section NUI Callbacks

--- Toggles NUI focus.
RegisterNUICallback('remove_nui_focus', function()
    SetNuiFocus(false, false)
end)

--- Handles vehicle actions for all events.
RegisterNUICallback('handle_vehicle_action', function(data)
    if not data then return NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('nui_data_missing'), duration = 3000 }) end
    if not data.event_type then return NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('nui_data_type_missing'), duration = 3000 }) end
    if not data.event_name then return NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('nui_data_name_missing'), duration = 3000 }) end
    
    local type_handler = data.event_type == 'client' and ':cl:' or ':sv:'
    local event_string = ('vehicle_menu%s%s'):format(type_handler, data.event_name)

    if data.event_type == 'client' then
        TriggerEvent(event_string, data.event_value)
        return
    end
    
    if data.event_type == 'server' then
        TriggerServerEvent(event_string, data.event_value)
        return
    end
end)

--- @section Events

--- Event to trigger toggle engine function
RegisterNetEvent('vehicle_menu:cl:toggle_vehicle_engine', function()
    toggle_engine()
end)

--- Event to trigger toggle door function on closest vehicle
--- @param data: Params table received from menu.
RegisterNetEvent('vehicle_menu:cl:toggle_vehicle_doors', function(door_index)
    vehicle_data = VEHICLES.get_vehicle_details(true)
    toggle_door(vehicle_data.vehicle, door_index)
end)

--- Function to toggle vehicle window
--- @param vehicle: The vehicle to toggle windows for.
--- @param window_index: The window to toggle or 'all' for all windows.
local function toggle_window(vehicle, window_index)
    if window_index == -1 then
        local any_window_down = false
        for i = 0, 3 do
            if window_states[i+1] then
                any_window_down = true
                break
            end
        end
        for i = 0, 3 do
            if any_window_down then
                RollUpWindow(vehicle, i)
                window_states[i+1] = false
            else
                RollDownWindow(vehicle, i)
                window_states[i+1] = true
            end
        end
    else
        if window_states[window_index + 1] then
            RollUpWindow(vehicle, window_index)
            window_states[window_index + 1] = false
        else
            RollDownWindow(vehicle, window_index)
            window_states[window_index + 1] = true
        end
    end
end

--- Event to trigger toggle window function
--- @param data: Params table received from menu.
RegisterNetEvent('vehicle_menu:cl:toggle_vehicle_windows', function(door_index)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and DoesEntityExist(vehicle) then
        toggle_window(vehicle, door_index)
    end
end)

--- @section Keymapping

RegisterCommand('vehicle:action_menu', function()
    local player_ped = PlayerPedId()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open_vehicle_menu' })
end, false)
RegisterKeyMapping('vehicle:action_menu', 'Open Action Menu', 'keyboard', MENU_KEY)

local is_in_sand = false

RegisterCommand('vehicle:sand', function()
    is_in_sand = not is_in_sand
    CreateThread(function()
        while is_in_sand do
            Wait(0)
            local player = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(player, false)
            if vehicle and vehicle ~= 0 then
                local num_wheels = GetVehicleNumberOfWheels(vehicle)
                for i = 2, num_wheels - 1 do
                    SetVehicleWheelTireColliderSize(vehicle, i, 0.1)
                end
                local rear_bone_index = GetEntityBoneIndexByName(vehicle, 'bodyshell')
                if rear_bone_index ~= -1 then
                    local rear_bone_pos = GetWorldPositionOfEntityBone(vehicle, rear_bone_index)
                    ApplyForceToEntity(vehicle, 1, 0.0, 0.0, -100.0, rear_bone_pos.x, rear_bone_pos.y, rear_bone_pos.z, false, true, true, false, false, true)
                end
            end
        end
    end)
end, false)
