draw_text(40, 30, "boss demo — SPACE damages, ENTER restarts");
draw_text(40, 55, "phase " + string(fight.phase) + " of " + string(fight.phases)
    + (fight.invulnerable ? "   (transition — invulnerable)" : ""));

draw_rectangle(40, 85, 40 + 600 * boss_fraction(fight), 105, false);
draw_rectangle(40, 85, 640, 105, true);

draw_text(40, 125, boss_telegraphing(fight)
    ? "winding up " + boss_move(fight)
        + "  " + string_format(boss_telegraph_fraction(fight) * 100, 3, 0) + "%"
    : (boss_attacking(fight) ? boss_move(fight) + " active"
        : (boss_dead(fight) ? "defeated" : "recovering — your turn")));

for (var i = 0; i < array_length(log_lines); i++) {
    draw_text(700, 160 + i * 20, log_lines[i]);
}
