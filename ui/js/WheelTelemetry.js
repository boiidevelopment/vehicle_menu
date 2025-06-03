class WheelTelemetry {
    constructor() {
        this.container = document.createElement('div');
        this.container.style.position = 'absolute';
        this.container.style.left = '30px';
        this.container.style.top = '50px';
        this.container.style.background = '#141414';
        this.container.style.borderRadius = '4px';
        this.container.style.boxShadow = '0 3px 5px rgba(0, 0, 0, 0.8)';
        this.container.style.padding = '10px';
        this.container.style.display = 'flex';
        this.container.style.flexWrap = 'wrap';
        this.container.style.justifyContent = 'center';
        this.container.style.alignItems = 'center';
        this.canvas = document.createElement('canvas');
        this.ctx = this.canvas.getContext('2d');
        this.container.appendChild(this.canvas);
        document.getElementById('main_container').appendChild(this.container);
        this.wheel_data = {};
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

    update_wheel_data(wheels) {
        this.wheel_data = wheels;
        this.resize_canvas();
    }

    resize_canvas() {
        const num_wheels = Object.keys(this.wheel_data).length;
        const cols = num_wheels <= 4 ? 2 : 3;
        const rows = Math.ceil(num_wheels / cols);
        this.canvas.width = cols * 200; 
        this.canvas.height = rows * 150; 
        this.container.style.width = `${this.canvas.width + 20}px`;
        this.container.style.height = `${this.canvas.height + 20}px`;
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
        let index = 0;
        const num_wheels = Object.keys(this.wheel_data).length;
        const cols = num_wheels <= 4 ? 2 : 3;
        const spacing_x = this.canvas.width / cols;
        const spacing_y = this.canvas.height / Math.ceil(num_wheels / cols);
        Object.keys(this.wheel_data).forEach((wheel) => {
            const data = this.wheel_data[wheel];
            const col = index % cols;
            const row = Math.floor(index / cols);
            const wheel_x = col * spacing_x + 20;
            const wheel_y = row * spacing_y + 20;
            ctx.fillStyle = '#fff';
            ctx.font = '16px Kanit';
            ctx.fillText(`Wheel ${wheel}`, wheel_x, wheel_y);
            this.draw_progress_bar(wheel_x, wheel_y + 10, 120, 8, data.health, 100, '#b53232');
            this.draw_text(wheel_x + 130, wheel_y + 18, `${Math.round(data.health)}%`);
            this.draw_progress_bar(wheel_x, wheel_y + 30, 120, 8, data.power, 1, '#4dcbc2');
            this.draw_text(wheel_x + 130, wheel_y + 38, `${data.power.toFixed(2)}`);
            this.draw_text(wheel_x, wheel_y + 60, `Speed: ${data.speed.toFixed(2)} km/h`);
            this.draw_text(wheel_x, wheel_y + 80, `Angle: ${data.steering_angle.toFixed(2)}°`);
            this.draw_text(wheel_x, wheel_y + 100, `Compression: ${data.suspension_compression.toFixed(2)}`);
            this.draw_text(wheel_x, wheel_y + 120, `Traction: ${data.traction.toFixed(2)}`);

            index++;
        });

        requestAnimationFrame(() => this.draw());
    }
}

/*
let WHEEL_TELEMETRY = new WheelTelemetry();

function simulate_wheel_telemetry() {
    if (!WHEEL_TELEMETRY) {
        WHEEL_TELEMETRY = new WheelTelemetry();
    }
    const test_wheel_data = {};
    for (let i = 1; i <= 6; i++) {
        test_wheel_data[i] = {
            health: Math.random() * 100,
            power: Math.random(),
            speed: Math.random() * 150,
            steering_angle: (Math.random() - 0.5) * 45,
            suspension_compression: Math.random() * 1.5,
            traction: Math.random() * 2,
        };
    }
    WHEEL_TELEMETRY.update_wheel_data(test_wheel_data);
}

setInterval(simulate_wheel_telemetry, 500);
*/