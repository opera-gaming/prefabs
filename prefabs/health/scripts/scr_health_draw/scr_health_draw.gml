/// @function health_draw_bar(x, y, width, height, state)
/// @description A bar at (x, y) with an outline, filled left to right.
/// Colours from green to red as it empties.
function health_draw_bar(x, y, width, height, state) {
    var _f = health_fraction(state);
    draw_set_colour(merge_colour(c_red, c_lime, _f));
    draw_rectangle(x, y, x + width * _f, y + height, false);
    draw_set_colour(c_white);
    draw_rectangle(x, y, x + width, y + height, true);
}
