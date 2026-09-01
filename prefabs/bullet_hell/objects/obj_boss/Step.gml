if (!::kernel::kernel_playing()) exit;

drift += delta_time / 1000000;
x = room_width / 2 + sin(drift * 0.7) * 220;

var _ev = ::boss::boss_step(fight);
if (_ev == "phase") {
    fight.invulnerable = true;
    alarm[0] = 40;
}
// The pattern is emitted when the wind-up ends, so a wall of bullets never
// arrives without warning.
if (_ev == "telegraph_end") hell_emit(::boss::boss_move(fight));

if (::boss::boss_ready(fight)) {
    var _pick = ::boss::boss_pick(fight, moves);
    if (_pick != "") {
        ::boss::boss_begin(fight, _pick,
            telegraph_seconds, 0.3,
            recover_seconds);
    }
}
