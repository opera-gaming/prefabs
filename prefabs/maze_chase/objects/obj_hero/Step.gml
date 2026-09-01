if (!::kernel::kernel_playing()) exit;
::health::health_step(vitals);

// Axis at a time against the walls, so a corner does not stick.
var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
var _dy = keyboard_check(vk_down) - keyboard_check(vk_up);
if (_dx != 0 && !::motion::motion_blocked(noone, walls, x + _dx * move_speed, y)) x += _dx * move_speed;
if (_dy != 0 && !::motion::motion_blocked(noone, walls, x, y + _dy * move_speed)) y += _dy * move_speed;

var _dot = instance_place(x, y, obj_dot);
if (_dot != noone) {
    ::kernel::kernel_score_add(dot_score);
    instance_destroy(_dot);
}

// The i-frame window is what stops a ghost that stays overlapping taking
// every life in three frames.
if (place_meeting(x, y, obj_ghost)) {
    if (::health::health_hurt(vitals, 1)) {
        ::feel::feel_shake(0.25, 8);
        ::feel::feel_hitstop(0.08);
    }
}
