/// @function transition_draw_fade(state, colour)
/// @description A flat fade. Draw it in a GUI event, last, so it covers
/// the HUD as well — a transition the score sits on top of is not a
/// transition.
function transition_draw_fade(state, colour) {
    var _a = transition_cover(state);
    if (_a <= 0) return;
    draw_set_colour(colour);
    draw_set_alpha(_a);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

/// @function transition_draw_wipe(state, colour, from_left)
/// @description A hard edge crossing the screen instead of a fade.
function transition_draw_wipe(state, colour, from_left) {
    var _f = transition_cover(state);
    if (_f <= 0) return;
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    draw_set_colour(colour);
    if (from_left) {
        draw_rectangle(0, 0, _w * _f, _h, false);
    } else {
        draw_rectangle(_w * (1 - _f), 0, _w, _h, false);
    }
    draw_set_colour(c_white);
}

/// @function transition_draw_bars(state, colour)
/// @description Two bars closing from top and bottom.
function transition_draw_bars(state, colour) {
    var _f = transition_cover(state);
    if (_f <= 0) return;
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    draw_set_colour(colour);
    draw_rectangle(0, 0, _w, _h / 2 * _f, false);
    draw_rectangle(0, _h - _h / 2 * _f, _w, _h, false);
    draw_set_colour(c_white);
}
