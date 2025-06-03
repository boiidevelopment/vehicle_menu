--[[
    NOTES:

    Refer back to this section for links to resources covering things used within the config.

    Key Presses:
    - menu_toggle_key
    - donuts.stop_key
    - tank_turn.stop_key
    - launch_control.launch_key

    The keys you can use can be found here: https://github.com/boiidevelopment/boii_utils/blob/main/lib/modules/keys.lua

    Vehicle Classes:
    Resource uses GTA5 vehicle classes to restrict vehicle usage, learn more here: https://docs.fivem.net/natives/?_0x29439776AAA00A62

    Driving Styles: 
    Driving styles used by tasks, learn more here: https://docs.fivem.net/natives/?_0xDACE1BE37D88AF67

    Handling Mods:
    Handling mods applied to vehicles in various modes, learn more here: https://gtamods.com/wiki/Handling.meta
]]

config = config or {}
config.modes = config.modes or {}

--- @section Action Menu

config.menu_toggle_key = 'j' -- Refer to notes on Key Presses.

--- @section Auto Pilot

config.modes.auto_pilot = {
    allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 }, -- Refer to notes on Vehicle Classes.
    electric_only = true, -- Requires game build 3258 defaults all vehicles to true if gamebuild is not high enough.
    speed = 30.0, -- Speed auto pilot should drive in MPH.
    driving_style = 786603 -- Refer to notes on Driving Styles.
}

--- @section Bounce Mode

config.modes.bounce = {
    allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 }, -- Refer to notes on Vehicle Classes. 
    cooldown = 500, -- Cooldown between bounce modes in (ms).
    radius = 50.0 -- Radius for player sync.
}

--- @section Donut

config.modes.donuts = {
    allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 }, -- Refer to notes on Vehicle Classes.
    stop_key = 'space' -- Refer to notes on Key Presses.
}

--- @section Driving Modes

config.modes.driving_modes = {
    -- For allowed_vehicle_classes refer to notes on Vehicle Classes.
    -- For handling_mods refer to notes on Handling Mods.
    comfort = {
        allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 },
        handling_mods = {
            { 'fSuspensionForce', 1.2 },
            { 'fSuspensionCompDamp', 0.3 }, 
            { 'fSuspensionReboundDamp', 0.3 }, 
            { 'fSuspensionRaise', -0.02 }
        }
    },
    drag = {
        allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 },
        handling_mods = {
            { 'fDriveInertia', 1.2 },
            { 'fInitialDriveForce', 0.35 },
            { 'fSteeringLock', 15.0 },
            { 'fTractionCurveMax', 2.8 },
            { 'fTractionCurveMin', 2.5 },
            { 'fLowSpeedTractionLossMult', 0.0 },
            { 'fSuspensionForce', 1.8 },
            { 'fSuspensionCompDamp', 1.2 },
            { 'fSuspensionReboundDamp', 1.2 },
            { 'fSuspensionLowerLimit', -0.1 },
            { 'fSuspensionRaise', -0.05 },
            { 'fSuspensionBiasFront', 0.55 },
            { 'fAntiRollBarForce', 0.8 },
            { 'fAntiRollBarBiasFront', 0.5 }, 
            { 'fRollCentreHeightFront', 0.35 },
            { 'fRollCentreHeightRear', 0.35 }
        }
    },
    drift = {
        allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 },
        handling_mods = {
            { 'fSteeringLock', 25.0 },
            { 'fTractionCurveMax', -1.3 },
            { 'fTractionCurveMin', -0.6 }, 
            { 'fTractionCurveLateral', 3.0 },
            { 'fLowSpeedTractionLossMult', 1.5 },
            { 'fCamberStiffnesss', 0.6 },
            { 'fTractionBiasFront', 0.2 },
            { 'fTractionLossMult', 1.5 }
        }
    },
    eco = {
        allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 },
        handling_mods = {
            { 'fPetrolConsumptionRate', 0.5 },
            { 'fSuspensionForce', 1.1 },
            { 'fSuspensionCompDamp', 0.5 },
            { 'fSuspensionReboundDamp', 0.5 }
        }
    },  
    sport = {
        allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 },
        handling_mods = {
            { 'fTractionCurveMax', 3.0 },
            { 'fTractionCurveMin', 2.5 },
            { 'fSuspensionForce', 1.5 },
            { 'fSuspensionCompDamp', 0.8 }, 
            { 'fSuspensionReboundDamp', 0.8 }, 
            { 'fSuspensionBiasFront', 0.55 }
        }
    },
    track = {
        allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 },
        handling_mods = {
            { 'fTractionCurveMax', 3.5 },
            { 'fTractionCurveMin', 3.0 },
            { 'fSuspensionForce', 2.0 },
            { 'fSuspensionCompDamp', 1.0 },
            { 'fSuspensionReboundDamp', 1.0 },
            { 'fSuspensionBiasFront', 0.48 },
            { 'fHandBrakeForce', 1.5 }
        }
    }
}

--- @section Tank Turn

config.modes.tank_turn = {
    allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 }, -- Refer to notes on Vehicle Classes.
    stop_key = 'space' -- Refer to notes on Key Presses.
}

--- @section Launch Control

config.modes.launch_control = {
    allowed_vehicle_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 9, 12, 17, 18, 19, 20 }, -- Refer to notes on Vehicle Classes.
    rpm_limit = 4500, -- Sets the RPM limit for launching.
    launch_prime_time = 3000, -- Time taken to prime the launch control.
    launch_key = 'space', -- Refer to notes on Key Presses.
    handling_mods = { -- Refer to notes on Handling Mods.
        { 'fDriveInertia', 1.2 }, 
        { 'fInitialDriveForce', 0.35 },
        { 'fSteeringLock', 30.0 },
        { 'fTractionCurveMax', 2.5 },
        { 'fTractionCurveMin', 2.2 }, 
        { 'fTractionCurveLateral', 22.5 },
        { 'fLowSpeedTractionLossMult', 0.2 },
        { 'fTractionLossMult', 1.2 },
        { 'fClutchChangeRateScaleUpShift', 2.5 },
        { 'fInitialDriveMaxFlatVel', 150.0 },
        { 'fBrakeForce', 1.0 },
        { 'fHandBrakeForce', 1.5 }
    }
}