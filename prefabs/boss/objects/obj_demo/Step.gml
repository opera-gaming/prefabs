// One event per frame, so each of these drives exactly one thing.
var _ev = boss_step(fight);
switch (_ev) {
    case "phase":
        // Invulnerable through the transition, or a big hit skips a stage.
        fight.invulnerable = true;
        alarm[0] = 45;
        array_push(log_lines, "phase " + string(fight.phase));
        break;
    case "telegraph_end":
        // The wind-up is over: this is where the attack actually fires.
        array_push(log_lines, boss_move(fight) + " fires");
        repeat (fight.phase * 2) {
            array_push(shots, { x: 480, y: 200, dir: irandom(359), life: 1.4 });
        }
        break;
    case "attack_end":
        array_push(log_lines, "recovering");
        break;
}
while (array_length(log_lines) > 7) array_delete(log_lines, 0, 1);

if (boss_ready(fight)) {
    var _pick = boss_pick(fight, moves);
    if (_pick != "") boss_begin(fight, _pick, 0.9, 0.5, 1.1);
}

for (var i = array_length(shots) - 1; i >= 0; i--) {
    var _s = shots[i];
    _s.x += lengthdir_x(5, _s.dir);
    _s.y += lengthdir_y(5, _s.dir);
    _s.life -= delta_time / 1000000;
    if (_s.life <= 0) array_delete(shots, i, 1);
}

if (keyboard_check_pressed(vk_space)) boss_hurt(fight, 25);
if (keyboard_check_pressed(vk_enter)) { fight = boss_make(300, 3); shots = []; }
