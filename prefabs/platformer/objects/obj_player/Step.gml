if (won) exit;

var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
::motion::motion_platformer_step(
    jump, noone, _dx,
    keyboard_check(vk_space) || keyboard_check(vk_up),
    keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up)
);

// Falling out of the world is a loss, not a soft-lock.
if (y > room_height + 200) {
    ::feel::feel_shake(0.25, 6);
    room_restart();
}

// Touching a patrol costs the run. Checked before the pickups so a frame
// that is both a coin and a death does not award the coin first.
if (instance_place(x, y, obj_enemy) != noone) {
    ::feel::feel_shake(0.3, 8);
    room_restart();
    exit;
}

var _coin = instance_place(x, y, obj_coin);
if (_coin != noone) {
    var _t = platformer_tuning();
    global.coins_taken += 1;
    ::kernel::kernel_score_add(_t.coin_score);
    // GUI space, like the rest of the HUD — a world-space popup would
    // scroll away with the camera.
    ::feel::feel_pop(display_get_gui_width() / 2, 96, "+" + string(_t.coin_score));
    instance_destroy(_coin);
}

if (instance_place(x, y, obj_goal) != noone) {
    won = true;
    ::feel::feel_hitstop(0.12);
    ::kernel::kernel_game_over(true);
}

var _p = ::camera::camera_follow_step(cam, x, y);
camera_set_view_pos(view_camera[0], _p.x, _p.y);
