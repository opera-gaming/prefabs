if (!::kernel::kernel_playing()) exit;
::kernel::kernel_tick();

scroll = min(scroll_max,
    scroll + scroll_gain);

travelled += scroll;
// Score *is* distance here, so bank the metres gained this step. It used to
// add zero while the run banked `runner_distance()` under "high_score", and
// the results screen read "score 0 / best 137" — two units under labels that
// look like they should agree.
var _gained = floor(runner_distance()) - scored_to;
if (_gained > 0) {
    ::kernel::kernel_score_add(_gained);
    scored_to += _gained;
}
next_x -= scroll;
while (next_x < room_width + cell * 2) runner_emit_column();

// Falling off the bottom is the only ending.
// Looked up rather than cached from Create: the player is a placed room
// entry now, so drag it somewhere else and this still finds it.
var _player = instance_find(obj_player, 0);
if (_player != noone && _player.y > room_height + 80) {
    ::kernel::kernel_game_over("fell");
    ::kernel::kernel_save_high_score(runner_distance());
    room_goto(rm_results);
}
