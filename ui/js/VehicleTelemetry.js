class VehicleTelemetry {
    constructor() {
        this.container = document.createElement('div');
        this.container.style.position = 'absolute';
        this.container.style.left = '500px';
        this.container.style.top = '50px';
        this.container.style.background = '#141414';
        this.container.style.borderRadius = '4px';
        this.container.style.boxShadow = '0 3px 5px rgba(0, 0, 0, 0.8)';
        this.container.style.padding = '10px';
        this.container.style.display = 'flex';
        this.container.style.flexDirection = 'column';
        this.container.style.gap = '8px';

        this.canvas = document.createElement('canvas');
        this.canvas.width = 290;
        this.canvas.height = 210;
        this.ctx = this.canvas.getContext('2d');

        this.container.appendChild(this.canvas);
        document.getElementById('main_container').appendChild(this.container);

        this.vehicle_data = {};
        this.enable_drag();
        this.draw();
    }

    enable_drag() {
        let offset_x = 0, offset_y = 0, is_dragging = false;

        this.container.addEventListener('mousedown', (e) => {
            is_dragging = true;
            offset_x = e.clientX - this.container.offsetLeft;
            offset_y = e.clientY - this.container.offsetTop;
            this.container.style.cursor = 'grabbing';
            $('#grid_overlay').removeClass('hidden');
        });

        document.addEventListener('mousemove', (e) => {
            if (!is_dragging) return;
            this.container.style.left = `${e.clientX - offset_x}px`;
            this.container.style.top = `${e.clientY - offset_y}px`;
        });

        document.addEventListener('mouseup', () => {
            is_dragging = false;
            this.container.style.cursor = 'grab';
            $('#grid_overlay').addClass('hidden');
        });
    }

    update_vehicle_data(data) {
        this.vehicle_data = data;
    }

    draw_progress_bar(x, y, width, height, value, max_value, color) {
        const ctx = this.ctx;
        ctx.fillStyle = '#333';
        ctx.fillRect(x, y, width, height);

        const filled_width = (Math.max(0, Math.min(value, max_value)) / max_value) * width;
        ctx.fillStyle = color;
        ctx.fillRect(x, y, filled_width, height);
    }

    draw_text(x, y, text, align = 'left') {
        const ctx = this.ctx;
        ctx.fillStyle = '#fff';
        ctx.font = '14px Kanit';
        ctx.textAlign = align;
        ctx.fillText(text, x, y);
    }

    draw() {
        const ctx = this.ctx;
        ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        ctx.fillStyle = '#1f1e1e';
        ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

        const bar_width = 100;
        const bar_height = 10;
        let y_offset = 20;
        const spacing = 20;

        const sections = [
            { label: 'Body Health', key: 'body_health', max: 1000, color: '#b53232' },
            { label: 'Engine Health', key: 'engine_health', max: 1000, color: '#b53232' },
            { label: 'Engine Temp', key: 'engine_temperature', max: 150, color: '#ff8c00' },
            { label: 'Fuel Level', key: 'fuel_level', max: 100, color: '#4dcbc2' },
            { label: 'Oil Level', key: 'oil_level', max: 100, color: '#b53232' },
            { label: 'Oil Temp', key: 'oil_temp', max: 150, color: '#ff8c00' },
            { label: 'Oil Pressure', key: 'oil_pressure', max: 10, color: '#ff8c00' },
            { label: 'Coolant Temp', key: 'coolant_temp', max: 150, color: '#ff8c00' },
            { label: 'Vacuum Pressure', key: 'vacuum_pressure', max: 1, color: '#ff8c00' },
            { label: 'Turbo Pressure', key: 'turbo_pressure', max: 2, color: '#ff8c00' }
        ];

        sections.forEach((item) => {
            this.draw_text(10, y_offset, item.label);
            this.draw_progress_bar(130, y_offset - 9, bar_width, bar_height, this.vehicle_data[item.key] || 0, item.max, item.color);
            this.draw_text(280, y_offset, (this.vehicle_data[item.key] || 0).toFixed(1), 'right');
            y_offset += spacing;
        });

        requestAnimationFrame(() => this.draw());
    }
}

/*
let VEHICLE_TELEMETRY = new VehicleTelemetry();

function simulate_vehicle_telemetry() {
    const test_vehicle_data = {
        body_health: Math.random() * 1000,
        engine_health: Math.random() * 1000,
        engine_temperature: Math.random() * 150,
        fuel_level: Math.random() * 100,
        oil_level: Math.random() * 100,
        oil_temp: Math.random() * 150,
        oil_pressure: Math.random() * 10,
        coolant_temp: Math.random() * 150,
        vacuum_pressure: Math.random(),
        turbo_pressure: Math.random() * 2
    };
    VEHICLE_TELEMETRY.update_vehicle_data(test_vehicle_data);
}

setInterval(simulate_vehicle_telemetry, 500);
*/