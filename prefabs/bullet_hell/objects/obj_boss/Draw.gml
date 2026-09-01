// The telegraph, made visible — a ring that closes as the wind-up runs.
if (::boss::boss_telegraphing(fight)) {
    var _t = ::boss::boss_telegraph_fraction(fight);
    draw_set_alpha(0.25 + _t * 0.6);
    draw_set_colour(c_red);
    draw_circle(x, y, 200 - _t * 150, true);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
draw_self();
