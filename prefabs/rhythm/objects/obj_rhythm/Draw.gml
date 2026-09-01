// The playfield, behind the notes. `make_colour_rgb` rather than a `$` literal:
// GameMaker's hex literals are $BBGGRR, so an RGB value pasted from a palette
// comes out with its red and blue swapped.
var _lane_a = make_colour_rgb(30, 33, 48);
var _lane_b = make_colour_rgb(36, 40, 56);
var _rim    = make_colour_rgb(58, 64, 84);

draw_set_alpha(1);
for (var l = 0; l < lanes; l++) {
    var cx = lane_x[l];
    draw_set_colour(l % 2 == 0 ? _lane_a : _lane_b);
    draw_rectangle(cx - 38, 0, cx + 38, room_height, false);
}
draw_sprite_ext(spr_hitline, 0, 320, hit_y, 1, 1, 0, c_white, 0.85);
draw_set_colour(_rim);
for (var l = 0; l < lanes; l++) {
    draw_rectangle(lane_x[l] - 30, hit_y - 12, lane_x[l] + 30, hit_y + 12, true);
}
draw_set_colour(c_white);
