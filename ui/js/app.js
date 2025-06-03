/// NUI Message Handlers

let VEHICLE_MENU = null;
let G_METER = null;
let WHEEL_TELEMETRY = null;
let VEHICLE_TELEMETRY = null;

const MESSAGE_HANDLERS = {
    open_vehicle_menu: () => {
        if (!VEHICLE_MENU) {
            VEHICLE_MENU = new VehicleMenu(VEHICLE_MENU_DATA);
        }
    },
    force_close_vehicle_menu: () => {
        if (VEHICLE_MENU) {
            VEHICLE_MENU.close();
        }
    },
    update_g_meter: (data) => {
        if (G_METER) {
            G_METER.update_g_forces(data.accel, data.brake, data.left, data.right);
            G_METER.update_segment('top', data.accel * 100);
            G_METER.update_segment('right', data.right * 100);
            G_METER.update_segment('bottom', data.brake * 100);
            G_METER.update_segment('left', data.left * 100);
        }
    },
    toggle_g_meter: () => {
        if (G_METER) {
            G_METER.container.remove();
            G_METER = null;
        } else {
            G_METER = new GMeter();
        }
    },
    update_wheel_telemetry: (data) => {
        if (WHEEL_TELEMETRY) {
            WHEEL_TELEMETRY.update_wheel_data(data.wheels);
        }
    },
    toggle_wheel_telemetry: () => {
        if (WHEEL_TELEMETRY) {
            WHEEL_TELEMETRY.container.remove();
            WHEEL_TELEMETRY = null;
        } else {
            WHEEL_TELEMETRY = new WheelTelemetry();
        }
    },
    update_vehicle_telemetry: (data) => {
        if (VEHICLE_TELEMETRY) {
            VEHICLE_TELEMETRY.update_vehicle_data(data.data);
        }
    },
    toggle_vehicle_telemetry: () => {
        if (VEHICLE_TELEMETRY) {
            VEHICLE_TELEMETRY.container.remove();
            VEHICLE_TELEMETRY = null;
        } else {
            VEHICLE_TELEMETRY = new VehicleTelemetry();
        }
    }
};

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action && MESSAGE_HANDLERS[data.action]) {
        MESSAGE_HANDLERS[data.action](data);
    }
});