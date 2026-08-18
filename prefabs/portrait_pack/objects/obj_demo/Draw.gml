draw_self();
if (array_length(grid) == 0) {
    draw_set_halign(fa_center);
    draw_text(640, 360, "(no previewable sprites)");
    draw_set_halign(fa_left);
    exit;
}
var _sel = grid[sel_row][sel_col];

// Yellow selection square around the selected icon.
var _pad = 3;
draw_set_colour(c_yellow);
for (var i = 0; i < 2; i++) {
    draw_rectangle(_sel.x - _pad - i, _sel.y - _pad - i, _sel.x + _sel.w + _pad + i, _sel.y + _sel.h + _pad + i, true);
}

// Preview panel (lower-right).
draw_set_colour(make_colour_rgb(45, 45, 52));
draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, false);
draw_set_colour(c_yellow);
draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, true);

// Selected sprite, fit-scaled into the panel and animated if multi-frame.
var _sw = sprite_get_width(_sel.s), _sh = sprite_get_height(_sel.s);
var _iw = (panel_x2 - panel_x1) - 16, _ih = (panel_y2 - panel_y1) - 40;
var _sc = min(_iw / _sw, _ih / _sh, 8);
var _cx = (panel_x1 + panel_x2) * 0.5;
var _cy = (panel_y1 + panel_y2) * 0.5 + 12;
var _n = sprite_get_number(_sel.s);
var _f = (_n > 1) ? (floor(current_time / 80) mod _n) : 0;
draw_sprite_ext(_sel.s, _f, _cx - _sw * _sc * 0.5, _cy - _sh * _sc * 0.5, _sc, _sc, 0, c_white, 1);

// Name label.
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_text(_cx, panel_y1 + 8, sprite_get_name(_sel.s));
draw_set_halign(fa_left);
