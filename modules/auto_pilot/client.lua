--- @section Constants

local ALLOWED_VEHICLES <const> = config.modes.auto_pilot.allowed_vehicle_classes
local SPEED <const> = config.modes.auto_pilot.speed / 2.23594
local DRIVING_STYLE <const> = config.modes.auto_pilot.driving_style

--- @section Variables

local autopilot_active = false

--- @section Functions

--- Checks if a vehicle is electric.
--- @param vehicle number: The vehicle entity.
--- @return boolean: True if the vehicle is electric, false otherwise.
local function is_electric_vehicle(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    if is_modern_game_build() then
        return GetIsVehicleElectric(GetEntityModel(vehicle))
    end
    return true
end

--- Stops autopilot mode.
--- @param vehicle number: The players vehicle.
--- @param player number: The players ped.
local function stop_autopilot(player)
    if not autopilot_active then return end
    autopilot_active = false
    ClearPedTasks(player)
    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('autopilot_disengaged'), duration = 3000 })
end

--- Starts autopilot mode.
local function start_autopilot()
    if autopilot_active then return end
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    if vehicle == 0 then return NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('not_in_vehicle'), duration = 3000 })  end
    if not is_allowed_vehicle(ALLOWED_VEHICLES, vehicle) then return NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('vehicle_not_allowed'), duration = 3000 }) end
    if config.modes.auto_pilot.electric_only and not is_electric_vehicle(vehicle) then return NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('not_electric'), duration = 3000 }) end
    local blip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blip) then return NOTIFICATIONS.send({ type = 'error', header = L('notification_header'), message = L('no_waypoint'), duration = 3000 }) end
    local coords = GetBlipCoords(blip)
    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = true }
    if not trigger_vehicle_method('toggle_autopilot', response) then return end
    TaskVehicleDriveToCoordLongrange(player, vehicle, coords.x, coords.y, coords.z, SPEED, DRIVING_STYLE, 10.0)
    autopilot_active = true
    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('autopilot_engaged'), duration = 3000 })
    CreateThread(function()
        while autopilot_active do
            local dist = #(GetEntityCoords(vehicle) - coords)
            if dist < 10.0 or not IsPedInAnyVehicle(player, false) then
                stop_autopilot(player)
            end
            Wait(1000)
        end
    end)
end

--- @section Commands

--- Handles toggling autopilot.
RegisterNetEvent('vehicle_menu:cl:toggle_autopilot', function()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    local is_active = not autopilot_active

    local response = { source = GetPlayerServerId(PlayerId()), player = player, vehicle = vehicle, is_active = is_active }
    if not trigger_vehicle_method('toggle_autopilot', response) then return end
    
    if not is_active then
        stop_autopilot(vehicle, player)
        return
    end
    start_autopilot()
end)
