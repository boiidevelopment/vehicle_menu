class GMeter {
    constructor() {
        this.container = document.createElement('div');
        this.container.style.position = 'absolute';
        this.container.style.left = '30px';
        this.container.style.top = '400px';
        this.container.style.cursor = 'grab';
        this.container.style.boxShadow = '0 3px 5px rgba(0, 0, 0, 0.8)';
        this.container.style.borderRadius = '4px';
        this.container.style.background = '#141414';
        this.container.style.padding = '5px';
        this.canvas = document.createElement('canvas');
        this.canvas.width = 280;
        this.canvas.height = 250;
        this.ctx = this.canvas.getContext('2d');
        this.segment_values = { top: 0, right: 0, bottom: 0, left: 0 };
        this.g_force = { x: 0, y: 0 };
        this.container.appendChild(this.canvas);
        document.getElementById('main_container').appendChild(this.container);
        this.enable_drag();
        this.draw();
    }

    enable_drag() {
        let offset_x = 0, offset_y = 0, is_dragging = false;

        this.container.addEventListener('mousedown', (e) => {
            $('#grid_overlay').removeClass('hidden');
            is_dragging = true;
            offset_x = e.clientX - this.container.offsetLeft;
            offset_y = e.clientY - this.container.offsetTop;
            this.container.style.cursor = 'grabbing';
        });

        document.addEventListener('mousemove', (e) => {
            if (!is_dragging) return;
            this.container.style.left = `${e.clientX - offset_x}px`;
            this.container.style.top = `${e.clientY - offset_y}px`;
        });

        document.addEventListener('mouseup', () => {
            $('#grid_overlay').addClass('hidden');
            is_dragging = false;
            this.container.style.cursor = 'grab';
        });
    }

    draw_background() {
        const ctx = this.ctx;
        ctx.fillStyle = '#141414';
        ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
    }

    draw_segment(start_angle, end_angle, value, color, reverse_fill = false) {
        const ctx = this.ctx;
        const center_x = this.canvas.width / 2;
        const center_y = this.canvas.height / 2;
        const radius = 93;
        const line_width = 20;
        const gap_offset = 0.3;
        let new_start = start_angle + gap_offset;
        let new_end = end_angle - gap_offset;
        if (reverse_fill) {
            new_start = end_angle - gap_offset;
            new_end = start_angle + gap_offset;
        }
        ctx.beginPath();
        ctx.arc(center_x, center_y, radius, new_start, new_start + (new_end - new_start) * (value / 100), reverse_fill);
        ctx.strokeStyle = color;
        ctx.lineWidth = line_width;
        ctx.stroke();
    }
    
    draw_target() {
        const ctx = this.ctx;
        const center_x = this.canvas.width / 2;
        const center_y = this.canvas.height / 2;
        ctx.strokeStyle = '#666';
        ctx.lineWidth = 2;
        for (let i = 25; i <= 90; i += 25) {
            ctx.beginPath();
            ctx.arc(center_x, center_y, i, 0, 2 * Math.PI);
            ctx.stroke();
        }
        ctx.beginPath();
        ctx.moveTo(center_x, center_y - 75);
        ctx.lineTo(center_x, center_y + 75);
        ctx.moveTo(center_x - 75, center_y);
        ctx.lineTo(center_x + 75, center_y);
        ctx.stroke();
    }

    draw_indicator() {
        const ctx = this.ctx;
        const center_x = this.canvas.width / 2;
        const center_y = this.canvas.height / 2;
        const offset_x = this.g_force.x * 25;
        const offset_y = this.g_force.y * 25;
        ctx.fillStyle = '#fff';
        ctx.beginPath();
        ctx.arc(center_x + offset_x, center_y + offset_y, 5, 0, 2 * Math.PI);
        ctx.fill();
    }

    draw_g_force_labels() {
        const ctx = this.ctx;
        ctx.fillStyle = '#fff';
        ctx.font = 'bold 20px Kanit';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        const center_x = this.canvas.width / 2;
        const center_y = this.canvas.height / 2;
        ctx.fillText(`${this.segment_values.top.toFixed(1)}`, center_x, center_y - 90);
        ctx.fillText(`${this.segment_values.bottom.toFixed(1)}`, center_x, center_y + 93);
        ctx.fillText(`${this.segment_values.left.toFixed(1)}`, center_x - 100, center_y);
        ctx.fillText(`${this.segment_values.right.toFixed(1)}`, center_x + 100, center_y);
    }

    draw_text_labels() {
        const ctx = this.ctx;
        ctx.font = 'bold 14px Kanit';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        const center_x = this.canvas.width / 2;
        const center_y = this.canvas.height / 2;
        const radius = 105;
        const labels = [
            { text: 'LEFT', angle: Math.PI + 0.8, flip: false, color: '#fff' },        
            { text: 'RIGHT', angle: -0.8, flip: false, color: '#fff' },               
            { text: 'BRAKE', angle: Math.PI - 0.8, flip: true, color: '#b53232' },       
            { text: 'ACCEL', angle: 0.8, flip: true, color: '#4dcbc2' }            
        ];
        labels.forEach(({ text, angle, flip, color }) => {
            ctx.fillStyle = color;
            const text_radius = radius + 10;
            const start_angle = angle - (text.length * 0.05);
            const chars = flip ? text.split('').reverse() : text.split('');
            chars.forEach((char, index) => {
                const char_angle = start_angle + index * 0.1;
                ctx.save();
                ctx.translate(
                    center_x + text_radius * Math.cos(char_angle),
                    center_y + text_radius * Math.sin(char_angle)
                );
                ctx.rotate(char_angle + Math.PI / 2 + (flip ? Math.PI : 0));
                ctx.fillText(char, 0, 0);
                ctx.restore();
            });
        });
    }

    draw_g_force_value() {
        const ctx = this.ctx;
        const g_force_magnitude = Math.sqrt(this.g_force.x ** 2 + this.g_force.y ** 2).toFixed(1);
        const box_x = this.canvas.width - 50;
        const box_y = this.canvas.height - 30;
        const box_width = 50;
        const box_height = 22;
        ctx.fillStyle = "#fff";
        ctx.font = "bold 20px Kanit";
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.fillText(`${g_force_magnitude}G`, box_x + box_width / 2, box_y + box_height / 2);
    }
    
    draw() {
        const ctx = this.ctx;
        ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        this.draw_background();
        this.draw_target();

        this.draw_segment(1.5 * Math.PI, 2 * Math.PI, 100, '#323030');
        this.draw_segment(0, 0.5 * Math.PI, 100, '#323030');
        this.draw_segment(0.5 * Math.PI, Math.PI, 100, '#323030');
        this.draw_segment(Math.PI, 1.5 * Math.PI, 100, '#323030');

        this.draw_segment(1.5 * Math.PI, 2 * Math.PI, this.segment_values.top, '#fff');
        this.draw_segment(0, 0.5 * Math.PI, this.segment_values.right, '#4dcbc2', true);
        this.draw_segment(0.5 * Math.PI, Math.PI, this.segment_values.bottom, '#b53232');
        this.draw_segment(Math.PI, 1.5 * Math.PI, this.segment_values.left, '#fff', true);

        this.draw_indicator();
        this.draw_g_force_labels();
        this.draw_text_labels();
        this.draw_g_force_value();

        requestAnimationFrame(() => this.draw());
    }

    update_g_forces(accel, brake, left, right) {
        this.g_force.x = left - right;
        this.g_force.y = brake - accel;
    }

    update_segment(segment, value) {
        this.segment_values[segment] = Math.max(0, Math.min(100, value));
    }
}

/*
const g_meter = new GMeter();

setInterval(() => {
    const accel = Math.random() * 2 - 1;
    const brake = Math.random() * 2 - 1;
    const left = Math.random() * 2 - 1;
    const right = Math.random() * 2 - 1;
    g_meter.update_g_forces(accel, brake, left, right);
}, 500);

setInterval(() => {
    g_meter.update_segment('top', Math.random() * 100);
    g_meter.update_segment('right', Math.random() * 100);
    g_meter.update_segment('bottom', Math.random() * 100);
    g_meter.update_segment('left', Math.random() * 100);
}, 500);
*/