if (!::kernel::kernel_playing()) exit;

var _g = gravity_per_frame;
var _j = jump_strength;

// Jump only from the ground; the buffer lives in ::motion:: for a
// platformer, but a runner has one button and no coyote time to speak of.
if (grounded && (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up))) {
    vy = -_j;
    grounded = false;
    ::feel::feel_squash(0.4);
}

vy += _g;
y += vy;

// Land on whatever is directly below, one axis at a time.
grounded = false;
if (vy >= 0) {
    var _below = instance_place(x, y + 1, obj_ground);
    if (_below != noone) {
        y = _below.bbox_top - sprite_height / 2;
        vy = 0;
        grounded = true;
    }
}
