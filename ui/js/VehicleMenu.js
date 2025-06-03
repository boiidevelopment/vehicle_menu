/// Menu Data

const VEHICLE_MENU_DATA = {
    controls: [
        { label: 'Doors', sub_options: [
            { label: 'All', event: { type: 'client', name: 'toggle_vehicle_doors', value: -1 } },
            { label: 'Driver', event: { type: 'client', name: 'toggle_vehicle_doors', value: 0 }  },
            { label: 'Passenger', event: { type: 'client', name: 'toggle_vehicle_doors', value: 1 }  },
            { label: 'Driver R', event: { type: 'client', name: 'toggle_vehicle_doors', value: 2 }  },
            { label: 'Passenger R', event: { type: 'client', name: 'toggle_vehicle_doors', value: 3 }  },
            { label: 'Hood', event: { type: 'client', name: 'toggle_vehicle_doors', value: 4 }  },
            { label: 'Trunk', event: { type: 'client', name: 'toggle_vehicle_doors', value: 5 }  }
        ]},
        { label: 'Windows', sub_options: [
            { label: 'All', event: { type: 'client', name: 'toggle_vehicle_windows', value: -1 } },
            { label: 'Driver', event: { type: 'client', name: 'toggle_vehicle_windows', value: 0 } },
            { label: 'Passenger', event: { type: 'client', name: 'toggle_vehicle_windows', value: 1 } },
            { label: 'Driver R', event: { type: 'client', name: 'toggle_vehicle_windows', value: 2 } },
            { label: 'Passenger R', event: { type: 'client', name: 'toggle_vehicle_windows', value: 3 } }
        ]},
        { label: 'Engine', event: { type: 'client', name: 'toggle_vehicle_engine' }},
    ],
    modes: [
        { label: 'Comfort', event: { type: 'server', name: 'toggle_driving_mode', value: 'comfort' } },
        { label: 'Drag', event: { type: 'server', name: 'toggle_driving_mode', value: 'drag' } },
        { label: 'Drift', event: { type: 'server', name: 'toggle_driving_mode', value: 'drift' } },
        { label: 'Eco', event: { type: 'server', name: 'toggle_driving_mode', value: 'eco' } },
        { label: 'Sport', event: { type: 'server', name: 'toggle_driving_mode', value: 'sport' } },
        { label: 'Track', event: { type: 'server', name: 'toggle_driving_mode', value: 'track' } },
    ],
    stance: [
        { label: 'Wheel Offset', sub_options: [
            { label: 'Outside', event: { type: 'server', name: 'toggle_camber', value: 'outside' } },
            { label: 'Inside', event: { type: 'server', name: 'toggle_camber', value: 'inside' } },
            { label: 'Reset', event: { type: 'server', name: 'toggle_camber', value: 'reset' } }
        ]},
        { label: 'Camber', sub_options: [
            { label: 'Top', event: { type: 'server', name: 'toggle_toe', value: 'top' } },
            { label: 'Bottom', event: { type: 'server', name: 'toggle_toe', value: 'bottom' } },
            { label: 'Reset', event: { type: 'server', name: 'toggle_toe', value: 'reset' } }
        ]},
        { label: 'Suspension', sub_options: [
            { label: 'Raise', event: { type: 'server', name: 'toggle_suspension', value: 'raise' } },
            { label: 'Lower', event: { type: 'server', name: 'toggle_suspension', value: 'lower' } },
            { label: 'Reset', event: { type: 'server', name: 'toggle_suspension', value: 'reset' } }
        ]},
    ],
    telemetry: [
        { label: 'G-Force', event: { type: 'client', name: 'toggle_g_meter' } },
        { label: 'Vehicle', event: { type: 'client', name: 'toggle_vehicle_telemetry' } },
        { label: 'Wheels', event: { type: 'client', name: 'toggle_wheel_telemetry' } }
    ],
    extras: [
        { label: 'Auto-Pilot', event: { type: 'client', name: 'toggle_autopilot' } },
        { label: 'Bounce', event: { type: 'server', name: 'toggle_bounce' } },
        { label: 'Donuts', event: { type: 'server', name: 'toggle_donuts' } },
        { label: 'Launch Control', event: { type: 'server', name: 'activate_launch_control' } },
        { label: 'Tank Turn', sub_options: [
            { label: 'Left', event: { type: 'server', name: 'toggle_tank_turn', value: 'left' } },
            { label: 'Right', event: { type: 'server', name: 'toggle_tank_turn', value: 'right' } }
        ]}
    ]
};

class VehicleMenu {
    constructor(data) {
        this.data = data;
        this.main_container = $('#main_container');
        this.active_tab = Object.keys(this.data)[0];
        this.menu_position = JSON.parse(localStorage.getItem('vehicle_menu_position')) || { top: '500px', left: '500px' };
        this.build();
        this.bind_events();
    }    

    bind_events() {
        $(document).on('keyup', (e) => {
            e.stopPropagation();
            if (e.key === 'Escape') () => {
                this.close();
            };
        });
        this.init_drag();
    }

    close() {
        $('.menu_container').empty();
        VEHICLE_MENU = null;
        this.remove_nui_focus();
    }

    remove_nui_focus() {
        $.post(`https://${GetParentResourceName()}/remove_nui_focus`);
    }

    bind_option_events() {
        $('#toggle_focus').off('click').on('click', e => {
            this.remove_nui_focus();
        });

        $('#menu_close').off('click').on('click', e => {
            this.close();
        });


        $('.tab_button').off('click').on('click', e => {
            const tab = $(e.currentTarget).data('tab');
            this.switch_tab(tab);
        });
    
        $('.menu_option').off('click').on('click', function(e) {
            const option_ele = $(this);
            const submenu = option_ele.find('.submenu');
            if (submenu.length) {
                submenu.toggleClass('hidden');
                e.stopPropagation(); 
                return false;
            }
            const event_type = $(this).data('event-type') || 'undefined_type';
            const event_name = $(this).data('event-name') || 'undefined_name';
            const event_value = $(this).data('event-value') || null;
            $.post(`https://${GetParentResourceName()}/handle_vehicle_action`, JSON.stringify({ event_type, event_name, event_value }));
        });
    
        $('.submenu_option').off('click').on('click', function(e) {
            e.stopPropagation();
            const event_type = $(this).data('event-type') || 'undefined_type';
            const event_name = $(this).data('event-name') || 'undefined_name';
            const event_value = $(this).data('event-value') || null;
            $.post(`https://${GetParentResourceName()}/handle_vehicle_action`, JSON.stringify({ event_type, event_name, event_value }));
        });
    }
    
    build() {
        const tabs = Object.keys(this.data).map(tab => `
            <button class="tab_button ${tab === this.active_tab ? 'active' : ''}" data-tab="${tab}">
                ${tab.replace(/_/g, ' ').toUpperCase()}
            </button>
        `).join('');

        this.main_container.append(`
            <div class="menu_container" style="top: ${this.menu_position.top}; left: ${this.menu_position.left};">
                <div class="menu_header"><h2>VEHICLE MENU</h2></div>
                <div class="menu_tabs main">
                    <div class="tabs_scroll">
                        <button id="menu_close" class="control_button">CLOSE</button>
                        <button id="toggle_focus" class="control_button">UNFOCUS</button>
                        <button id="menu_drag" class="control_button">MOVE</button>
                    </div>
                </div>
                <div class="menu_tabs"><div class="tabs_scroll sub">${tabs}</div></div>
                <div class="menu_content">${this.build_tab_content(this.active_tab)}</div>
            </div>
        `);
        this.bind_option_events();
    }

    build_tab_content(tab) {
        const options = this.data[tab] || [];
        return options.map(option => {
            const event_type = option.event ? `data-event-type="${option.event.type}"` : "";
            const event_name = option.event ? `data-event-name="${option.event.name}"` : "";
            const event_value = option.event && option.event.value ? `data-event-value="${option.event.value}"` : "";
            return `
                <div class="menu_option ${option.sub_options ? 'has-submenu' : ''}" ${event_type} ${event_name} ${event_value}>
                    <span>${option.label}</span>
                    ${option.sub_options ? `<div class="submenu hidden">${this.build_submenu(option.sub_options)}</div>` : ''}
                </div>
            `;
        }).join('');
    }
    
    build_submenu(sub_options) {
        return sub_options.map(sub => {
            const event_type = sub.event ? `data-event-type="${sub.event.type}"` : "";
            const event_name = sub.event ? `data-event-name="${sub.event.name}"` : "";
            const event_value = sub.event && sub.event.value ? `data-event-value="${sub.event.value}"` : "";
            return `
                <div class="submenu_option" ${event_type} ${event_name} ${event_value}>
                    <span>${sub.label}</span>
                </div>
            `;
        }).join('');
    }

    switch_tab(tab) {
        this.active_tab = tab;
        $('.tab_button').removeClass('active');
        $(`.tab_button[data-tab="${tab}"]`).addClass('active');
        $('.menu_content').html(this.build_tab_content(tab));
        this.bind_option_events();
    }

    init_drag() {
        let offset_x = 0, offset_y = 0;
        const menu = $('.menu_container');

        $(document).on('mousedown', '#menu_drag', (e) => {
            this.is_dragging = true;
            offset_x = e.clientX - menu.position().left;
            offset_y = e.clientY - menu.position().top;
            menu.addClass('dragging');
            $('#grid_overlay').removeClass('hidden');
            e.preventDefault();
        });

        $(document).on('mousemove', (e) => {
            if (!this.is_dragging) return;
            menu.css({
                top: `${e.clientY - offset_y}px`,
                left: `${e.clientX - offset_x}px`
            });
        });

        $(document).on('mouseup', () => {
            if (this.is_dragging) {
                this.is_dragging = false;
                menu.removeClass('dragging');
                $('#grid_overlay').addClass('hidden');
                localStorage.setItem('vehicle_menu_position', JSON.stringify({ top: menu.css('top'), left: menu.css('left') }));
            }
        });
    }
}

/*
VEHICLE_MENU = new VehicleMenu(VEHICLE_MENU_DATA, 'j');

$('body').css({
    'background': 'grey'
});
*/