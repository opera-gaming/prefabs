if (!::kernel::kernel_playing()) exit;
::kernel::kernel_tick();

// True on exactly one frame, so the round ends once.
if (::timer::timer_step(clock)) {
    ::kernel::kernel_game_over("time");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
    exit;
}

if (instance_number(obj_target) == 0) {
    ::kernel::kernel_game_over("cleared");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
}
