--- @section Variables

local active_bounce_vehicles = {}

--- @section Events

--- Toggles bounce mode synced.
--- @param veh_netid: Vehicles net id.
--- @param active boolean: Active flag.
RegisterNetEvent('vehicle_menu:cl:toggle_bounce', function(veh_netid, active)
    local vehicle = NetworkGetEntityFromNetworkId(veh_netid)
    if not DoesEntityExist(vehicle) then return end
    local response = { source = GetPlayerServerId(PlayerId()), player = PlayerPedId(), vehicle = vehicle, is_active = active }
    if not trigger_vehicle_method('toggle_bounce', response) then return end
    active_bounce_vehicles[veh_netid] = active and { original_height = GetVehicleSuspensionHeight(vehicle), start_time = GetGameTimer() } or nil
    if not active then SetVehicleSuspensionHeight(vehicle, active_bounce_vehicles[veh_netid] and active_bounce_vehicles[veh_netid].original_height or 0) end
end)

--- @section Threads

--- Handles vehicle bouncing.
CreateThread(function()
    while true do
        while not next(active_bounce_vehicles) do
            Wait(500)
        end
        for veh_netid, data in pairs(active_bounce_vehicles) do
            local vehicle = NetworkGetEntityFromNetworkId(veh_netid)
            if DoesEntityExist(vehicle) then
                local current_time = GetGameTimer()
                local time_since_start = (current_time - data.start_time) / 1000.0
                local bounce_offset = 0.05 * math.sin(2 * math.pi * 1.5 * time_since_start)
                SetVehicleSuspensionHeight(vehicle, (data.original_height or 0) + bounce_offset)
            else
                active_bounce_vehicles[veh_netid] = nil
            end
        end
        Wait(0)
    end
end)