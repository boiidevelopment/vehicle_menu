# BOII Development - Vehicle Menu (STANDALONE)

## 📹 Preview

**[YouTube](https://www.youtube.com/watch?v=bYxgliM1iM4)**

## 🌍 Overview

Take full control of your vehicle with our new Standalone Vehicle Menu – a feature-packed, highly optimised menu built to elevate the driving scene!

This isn’t just another menu; it’s your all-in-one solution for stance adjustments, driving modes, live telemetry, and advanced vehicle controls. 
Want to slam your suspension, tweak your camber, or fine-tune your wheel offset? Done. 
Need real-time telemetry tracking G-forces, engine stats, and wheel data? Easy.

From precision handling to fun extras like bounce mode and tank turns, our menu puts virtually every tool at your fingertips ready to go.

As always, enjoy!

---

## 🌐 Features

### 🚗 **Vehicle Controls**
- Open/close **doors** individually or all at once.
- Roll windows **up/down** per seat or all together.
- Toggle **engine** on/off.

### 🏎️ **Driving Modes**
- Comfort
- Drag
- Drift
- Eco
- Sport
- Track

### 🏁 **Stance Adjustments**
- **Wheel Offset**: Move wheels **inside or outside** the fender.
- **Camber**: Adjust **top or bottom** angles for better grip.
- **Suspension**: **Raise, lower, or reset** the suspension height.

### 📊 **Live Telemetry**
- **G-Force Meter**: Real-time acceleration/braking forces.
- **Vehicle Telemetry**: Monitor **engine health, temperature, turbo pressure, fuel, and more**.
- **Wheel Telemetry**: Monito **wheel power, traction, speed, steering angle, and suspension compression**.

### 🎮 **Extras & Driving Assists**
- **Auto-Pilot**: Enable semi-autonomous driving.
- **Bounce Mode**: Add **hydraulics-like bounce** effect.
- **Donuts Mode**: Perform **perfect donuts** effortlessly.
- **Launch Control**: Optimize acceleration for **racing starts**.
- **Tank Turn**: Rotate the vehicle **in place** for sharp turns.

---

## 📷 Screenshots

![image](https://i.ibb.co/SDQKd6h8/image-2025-03-05-235121560.png)
![image](https://i.ibb.co/hxHY6K4q/telemetry.gif)
![image](https://i.ibb.co/B296HyLZ/image-2025-03-05-235557056.png)
![image](https://i.ibb.co/9k1VnScC/image-2025-03-05-235949163.png)
![image](https://i.ibb.co/jvR5VsSs/image-2025-03-05-235842106.png)
![image](https://i.ibb.co/5xYMK8N2/image-2025-03-06-000036063.png)
![image](https://i.ibb.co/spRJskzX/image-2025-03-06-000206296.png)

---

## 💹 Dependencies

- **[boii_utils v2.0 or above](https://github.com/boiidevelopment/boii_utils/releases/tag/v2.0.0)**

---

## 📦 Getting Started

Prior to installation make sure you have all of the dependencies listed above in your server and you have completed their setup steps in full.

1. Configuration:

Some options have a dedicated config section, you should adjust these to your requirements.
The `config.lua` contains a short notes section with some links to useful information that can help you adjust the resource to make it more personal.

2. UI Customisation: 

If you want to change the UI colour palette you can do do so here: `ui/css/root.css`
The menu uses these root colours however the canvas telemtry elements you can edit those within the constructors of each class. 

3. Resource Installation:

Since this is standalone it is just a drag and drop resource;

- After customising config add the resource into your server resources
- Type `refresh; ensure boii_vehiclemenu` into the console and you should be ready to go. 
- Or restart your server.

---

## 📦 Usage

1. Opening The Menu:

By default players can press `j` to open the vehicle menu, this can be done outside of a vehicle incase it needs to be closed however all actions must be performed by the driver.
You can change the default keymapping to toggle the menu in the `config.lua`.

The menu then has 2 relevant buttons; `CLOSE`, `TOGGLE FOCUS`
You can use `CLOSE` to close **only** the menu, this will leave any telemetry elements visible.
You can use `TOGGLE FOCUS` to toggle Nui focus leaving the menu on screen but enabling full movement -- push `j` to toggle focus back on.

2. UI Dragging: 

All of the included elements can be dragged to moved and positions will be saved locally.

Moveable Elements:
- Menu
- G-Meter
- Wheel Telemetry
- Vehicle Telemetry

3. Advanced Customisation: 

The resource comes with a event method registry.
This allows you to export into the resource externally to create and attach custom methods the the events used throughout.

For Example:

```lua
--- Registering an event method.
exports.boii_vehiclemenu:add_method('toggle_autopilot', function(response)
    local vehicle = response.vehicle -- Response options; 'source', 'player', 'vehicle', 'is_active'

    if GetVehicleClass(vehicle) == 8 then
        return false
    end
end)

--- Removing a registered method.
exports.boii_vehiclemenu:remove_method('toggle_autopilot')
```

---

## 📝 Notes

- Updated documentation for all resources is currently being worked on however none currently exists. This will be completed a.s.a.p, however it should not be required for this resource.
- Game build 3258+ is required for enabling some options on only electric vehicles. If you are on a lower gamebuild they will default to avaiable for none electric.
- Have some additional plans to add to this in future updates to cover telemetry for other vehicle type, planes, boats etc.

---

## 🤝 Suggestions

Suggestions for changes or additional things to add into resources are always welcome. 
If you have an idea for something you think a resource could include, should include, could be handled differently or anything inbetween, just reach out through discord.

---

## 📩 Links

* **[Discord](https://discord.gg/MUckUyS5Kq)**
* **[Documentation](https://docs.boii.dev/)**
* **[GitHub](https://github.com/boiidevelopment)**
* **[Tebex 1](https://boii.tebex.io)**
* **[Tebex 2](https://boiidevelopment.tebex.io/)**
* **[YouTube](https://youtube.com/boiidevelopment)**

---
## 💰 Other Resources

* **[Advanced Weed System](https://forum.cfx.re/t/advanced-weed-system-qb-qbox-esx-ox-nd/5306863)**
* **[Battlepass](https://forum.cfx.re/t/paid-multi-framework-battle-pass/5227019)**
* **[Crafting](https://forum.cfx.re/t/qb-esx-boii-custom-crafting-script-v1-0-0/5240948)**
* **[Daily Rewards](https://forum.cfx.re/t/paid-daily-rewards/5260533)**
* **[Drug Sales](https://forum.cfx.re/t/paid-qb-esx-boii-custom-drug-sales-v1-0-0/5240669)**
* **[Hobo Life](https://forum.cfx.re/t/paid-qb-esx-boii-custom-hobo-life-script-v1-0-0/5238389)**
* **[Loading Screens (7 in 1)](https://forum.cfx.re/t/paid-standalone-loading-screens-7-in-1/5252982)**
* **[Pawnshops](https://forum.cfx.re/t/paid-multi-framework-pawnshop-script-with-player-owned-support/5213001)**
* **[Petty Crimes](https://forum.cfx.re/t/paid-petty-crimes/5284805)**
* **[Roleplay Tests & Licence System](https://forum.cfx.re/t/paid-multi-framework-roleplay-tests-licence-system/5204855)**
* **[Stores](https://forum.cfx.re/t/paid-stores-script-qb-esx-boii-custom/5257205)**
* **[Vehicle Rentals](https://forum.cfx.re/t/paid-vehicle-rentals/5294250)**

*We do have a variety of older legacy resources however these have not been updated with multi-framework compatibility yet, this is being worked on, appreciate the patience. You can find legacy paid resources here: [Tebex 1](https://boii.tebex.io)*
