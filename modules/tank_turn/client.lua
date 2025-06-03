--- @section Constants

local ALLOWED_VEHICLES <const> = config.modes.tank_turn.allowed_vehicle_classes or {}
local STOP_KEY <const> = config.modes.tank_turn.stop_key

--- @section Variables
local active_tank_turns = {}

--- @section Functions

local function perform_tank_turn(vehicle, direction)
    if not DoesEntityExist(vehicle) or not is_allowed_vehicle(ALLOWED_VEHICLES, vehicle) then return end
    local player = PlayerPedId()
    if GetPedInVehicleSeat(vehicle, -1) ~= player then return end
    local steer_direction = direction == 'left' and 1.0 or -1.0
    active_tank_turns[vehicle] = true
    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('tank_turn_enabled', string.upper(STOP_KEY)), duration = 3000 })
    CreateThread(function()
        while active_tank_turns[vehicle] and DoesEntityExist(vehicle) do
            if IsControlJustPressed(0, KEY_LIST[STOP_KEY]) then
                active_tank_turns[vehicle] = nil
                break
            end
            SetVehicleSteerBias(vehicle, steer_direction)
            SetControlNormal(0, 71, 1.0)
            SetControlNormal(0, 72, 1.0)
            Wait(0)
        end
        SetControlNormal(0, 71, 0.0)
        SetControlNormal(0, 72, 0.0)
        SetVehicleSteerBias(vehicle, 0.0)
        active_tank_turns[vehicle] = nil
    end)
    CreateThread(function()
        while active_tank_turns[vehicle] and DoesEntityExist(vehicle) do
            local new_heading = (GetEntityHeading(vehicle) + (steer_direction * 2.5)) % 360
            SetEntityHeading(vehicle, new_heading)
            Wait(20)
        end
    end)
end

--- @section Events

--- Handles tank turns.
--- @param veh_netid: Vehicles NetID.
--- @param action: Action handler to perform.
--- @param direction string: Direction to turn.
RegisterNetEvent('vehicle_menu:cl:toggle_tank_turn', function(veh_netid, is_active, direction)
    local vehicle, player = NetworkGetEntityFromNetworkId(veh_netid), PlayerPedId()
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = is_active }
    if not DoesEntityExist(vehicle) or not is_allowed_vehicle(ALLOWED_VEHICLES, vehicle) or not trigger_vehicle_method('toggle_tank_turn', response) then return end
    active_tank_turns[vehicle] = is_active
    if is_active then 
        CreateThread(function() 
            perform_tank_turn(vehicle, direction or 'left') 
        end) 
    end
end)
