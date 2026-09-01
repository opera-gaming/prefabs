if (!::kernel::kernel_playing()) exit;

::health::health_step(vitals);

var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
var _dy = keyboard_check(vk_down) - keyboard_check(vk_up);
::motion::motion_topdown(obj_wall, _dx, _dy, move_speed);

// Touching an enemy costs health, but only once per i-frame window — that
// window is what stops a chaser that stays overlapping ending the run in
// three frames.
if (place_meeting(x, y, obj_enemy)) {
    var _t = top_down_arena_tuning();
    if (::health::health_hurt(vitals, _t.enemy_touch_damage)) {
        ::feel::feel_shake(0.2, 7);
        ::feel::feel_hitstop(0.06);
    }
}

if (::health::health_dead(vitals)) {
    ::kernel::kernel_game_over("overrun");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
}
