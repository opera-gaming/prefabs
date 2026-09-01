/// @function hud_label(x, y, text, halign)
/// @description Draw one line at an alignment and restore the previous one,
/// so a caller never inherits another caller's halign — the single most
/// common cross-component drawing bug.
function hud_label(x, y, text, halign) {
    var _was = draw_get_halign();
    draw_set_halign(halign);
    draw_text(x, y, text);
    draw_set_halign(_was);
}

/// @function hud_panel(x, y, width, height, alpha)
/// @description A dimmed backing rectangle, for putting text over a busy
/// game without it becoming unreadable.
function hud_panel(x, y, width, height, alpha) {
    draw_set_colour(c_black);
    draw_set_alpha(alpha);
    draw_rectangle(x, y, x + width, y + height, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
