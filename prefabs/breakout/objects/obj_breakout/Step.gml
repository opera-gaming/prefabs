if (!::kernel::kernel_playing()) exit;
::kernel::kernel_tick();

if (instance_number(obj_brick) == 0) {
    ::kernel::kernel_game_over("cleared");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
    exit;
}

// Dropped: the ball is past the bottom, which is the only losing condition.
var _ball = instance_find(obj_ball, 0);
if (_ball != noone && _ball.y > room_height + 20) {
    instance_destroy(_ball);
    lives_left -= 1;
    ::feel::feel_shake(0.3, 9);
    if (lives_left <= 0) {
        ::kernel::kernel_game_over("dropped");
        ::kernel::kernel_save_high_score(::kernel::kernel_score());
        room_goto(rm_results);
        exit;
    }
    breakout_serve();
}
