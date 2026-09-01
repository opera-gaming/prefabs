if (!::kernel::kernel_playing()) exit;

// Holding shift slows you down for precise threading — the other half of
// the small-hitbox bargain.
var _s = keyboard_check(vk_shift) ? speed_focus : speed_full;
var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
var _dy = keyboard_check(vk_down) - keyboard_check(vk_up);
x = clamp(x + _dx * _s, 12, room_width - 12);
y = clamp(y + _dy * _s, 12, room_height - 12);

// Fire on a cooldown rather than every frame, so the rate is a knob rather
// than the frame rate.
shot_cool -= delta_time / 1000000;
if (keyboard_check(vk_space) && shot_cool <= 0) {
    shot_cool = ::kernel::kernel_tuning("shot_interval", 0.12);
    ::projectile::projectile_launch(obj_shot, x, y - 14, 90,
        ::kernel::kernel_tuning("shot_speed", 9),
        ::kernel::kernel_tuning("shot_life", 2));
}

// Collision by distance against the tiny hitbox, not by sprite overlap.
// This is the whole genre: a hitbox matching the art makes a dense
// pattern impossible rather than difficult.
var _struck = false;
with (obj_bullet) {
    if (point_distance(x, y, other.x, other.y) <= other.hitbox + 5) {
        _struck = true;
        break;
    }
}
if (!_struck) exit;

::feel::feel_shake(0.4, 12);
::kernel::kernel_game_over("hit");
::kernel::kernel_save_high_score(::kernel::kernel_score());
room_goto(rm_results);
