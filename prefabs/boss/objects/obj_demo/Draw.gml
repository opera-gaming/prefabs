// The telegraph made visible: a marker that grows through the wind-up, so
// the dodge can be timed rather than guessed.
if (boss_telegraphing(fight)) {
    var _t = boss_telegraph_fraction(fight);
    draw_set_alpha(0.3 + _t * 0.7);
    draw_set_colour(c_red);
    draw_circle(480, 200, 40 + _t * 150, true);
    draw_set_alpha(1);
}
draw_set_colour(boss_attacking(fight) ? c_orange : c_white);
draw_circle(480, 200, 40, false);

draw_set_colour(c_yellow);
for (var i = 0; i < array_length(shots); i++) {
    draw_circle(shots[i].x, shots[i].y, 6, false);
}
draw_set_colour(c_white);
