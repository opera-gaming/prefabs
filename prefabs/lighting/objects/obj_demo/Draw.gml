// Something to actually light.
draw_set_colour(c_gray);
for (var i = 0; i < array_length(lamps); i++) {
    draw_circle(lamps[i][0], lamps[i][1], 18, false);
}
draw_set_colour(c_teal);
for (var _x = 60; _x < room_width; _x += 120) {
    draw_rectangle(_x, 300, _x + 60, 340, false);
}
draw_set_colour(c_white);

light_draw(night);
