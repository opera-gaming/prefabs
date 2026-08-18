// Asset-layer icons draw themselves; this event adds the selection box and the
// full-size preview panel on top.
draw_self(); // no sprite on this controller — harmless, keeps the event explicit
var _sel = grid[sel_row][sel_col];

// --- Yellow selection square around the selected icon ---
var _pad = 3;
var _x1 = _sel.x - _pad;
var _y1 = _sel.y - _pad;
var _x2 = _sel.x + _sel.w + _pad;
var _y2 = _sel.y + _sel.h + _pad;
draw_set_colour(c_yellow);
for (var i = 0; i < 2; i++) {            // 2px-thick outline
    draw_rectangle(_x1 - i, _y1 - i, _x2 + i, _y2 + i, true);
}

// --- Preview panel (lower-right) ---
draw_set_colour(make_colour_rgb(45, 45, 52)); // dark gray, not black
draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, false);
draw_set_colour(c_yellow);
draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, true);

// Full-size sprite, centred in the panel below the label.
var _cx = (panel_x1 + panel_x2) * 0.5;
var _cy = (panel_y1 + panel_y2) * 0.5 + 12;
draw_sprite(_sel.spr, 0, _cx - sprite_get_width(_sel.spr) * 0.5,
                         _cy - sprite_get_height(_sel.spr) * 0.5);

// Sprite name label.
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_text(_cx, panel_y1 + 8, sprite_get_name(_sel.spr));
draw_set_halign(fa_left);
draw_set_colour(c_white);
