// Something for the dim to sit over: a paused screenshot of an empty room
// shows the dim and nothing about what pausing is for.
for (var i = 0; i < 9; i++) {
    var _x = 120 + (i mod 3) * 320;
    var _y = 120 + (i div 3) * 150;
    var _p = t / 60 + i;
    draw_set_colour(make_colour_hsv((i * 26) mod 255, 150, 220));
    draw_rectangle(_x - 60, _y - 40 + sin(_p) * 18,
                   _x + 60, _y + 40 + sin(_p) * 18, false);
}
draw_set_colour(c_white);
