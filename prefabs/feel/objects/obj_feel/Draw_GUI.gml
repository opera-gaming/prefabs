for (var i = 0; i < array_length(pops); i++) {
    var _p = pops[i];
    var _t = _p.life / _p.span;
    draw_set_halign(fa_center);
    draw_set_alpha(1 - _t);
    draw_set_colour(_p.colour);
    draw_text(_p.x, _p.y - feel_tween(0, 34, _t, "out_quad"), _p.text);
    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_set_halign(fa_left);
}
