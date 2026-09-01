// The start marker and the coins are positions, not instances — found
// without spawning anything.
draw_set_colour(c_yellow);
var _spots = tilemap_find(level, cell, "o");
for (var i = 0; i < array_length(_spots); i++) {
    draw_circle(_spots[i].x, _spots[i].y, 7, false);
}
draw_set_colour(c_lime);
draw_circle(start.x, start.y, 11, false);
draw_set_colour(c_white);
