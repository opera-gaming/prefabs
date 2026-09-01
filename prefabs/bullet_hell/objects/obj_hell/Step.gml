if (!::kernel::kernel_playing()) exit;
::kernel::kernel_tick();
::timer::timer_step(survived);

// Surviving is the score, so it accrues per second rather than per event.
var _want = floor(::timer::timer_seconds(survived))
    * survive_score;
if (_want > tally) {
    ::kernel::kernel_score_add(_want - tally);
    tally = _want;
}

if (instance_exists(overlord) && ::boss::boss_dead(overlord.fight)) {
    ::kernel::kernel_game_over("cleared");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
}
