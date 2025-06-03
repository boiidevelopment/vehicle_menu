--- @section Constants

local ALLOWED_VEHICLES <const> = config.modes.donuts.allowed_vehicle_classes or {}
local STOP_KEY <const> = config.modes.donuts.stop_key

--- @section Variables

local active_donuts = {}

--- @section Functions

--- Performs donuts on player vehicle.
--- @param vehicle number: Player vehicle.
local function perform_donuts(vehicle)
    if not DoesEntityExist(vehicle) or not is_allowed_vehicle(ALLOWED_VEHICLES, vehicle) then return end
    local driver = GetPedInVehicleSeat(vehicle, -1)
    if driver ~= PlayerPedId() then return end
    local steer_control = { 30, 59, 64, 218, 342 } -- Only seem to be able to force it to turn one direction for some stupid reason; might look into it later.
    local initial_heading = GetEntityHeading(vehicle)
    NOTIFICATIONS.send({ type = 'info', header = L('notification_header'), message = L('donuts_enabled', string.upper(STOP_KEY)), duration = 3000 })
    CreateThread(function()
        while active_donuts[vehicle] and DoesEntityExist(vehicle) do
            if IsControlJustPressed(0, KEY_LIST[STOP_KEY]) then
                active_donuts[vehicle] = nil
                break
            end
            SetControlNormal(0, 71, 1.0)
            SetControlNormal(0, 72, 1.0)
            for _, control in ipairs(steer_control) do
                SetControlNormal(0, control, 1.0)
            end
            Wait(0)
        end
        active_donuts[vehicle] = nil
        SetControlNormal(0, 71, 0.0)
        SetControlNormal(0, 72, 0.0)
        for _, control in ipairs(steer_control) do
            SetControlNormal(0, control, 0.0)
        end
    end)
end

--- @section Events

--- Event to toggle donuts.
RegisterNetEvent('vehicle_menu:cl:toggle_donuts', function(veh_netid)
    local vehicle = NetworkGetEntityFromNetworkId(veh_netid)
    if not DoesEntityExist(vehicle) or not is_allowed_vehicle(ALLOWED_VEHICLES, vehicle) then return end
    local response = { source = GetPlayerServerId(PlayerId()), player = PlayerPedId(), vehicle = vehicle, is_active = not active_donuts[vehicle] }
    if not trigger_vehicle_method('toggle_donuts', response) then return end
    active_donuts[vehicle] = not active_donuts[vehicle]
    if active_donuts[vehicle] then perform_donuts(vehicle) end
end)
