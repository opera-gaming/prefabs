draw_self();
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_text(40, 24, "Sounds  -  Up/Down to select, Space/Enter to play");
var _n = array_length(sounds);
var _shown = min(25, _n);
for (var i = 0; i < _shown; i++) {
    var _idx = view_top + i;
    if (_idx >= _n) break;
    var _y = 64 + i * 24;
    if (_idx == sel) {
        draw_set_colour(c_yellow);
        draw_rectangle(34, _y - 2, 640, _y + 20, true);
        draw_text(40, _y, "> " + sounds[_idx]);
    } else {
        draw_set_colour(c_ltgray);
        draw_text(40, _y, "   " + sounds[_idx]);
    }
}
draw_set_colour(c_white);
draw_text(40, 64 + 25 * 24 + 8, string(sel + 1) + " / " + string(_n));
