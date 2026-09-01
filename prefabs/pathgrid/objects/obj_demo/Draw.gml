draw_set_colour(c_lime);
draw_circle(80, 260, 10, false);

// An empty route is a normal state — the target is inside a wall.
draw_set_colour(array_length(route) > 0 ? c_yellow : c_red);
for (var i = 0; i < array_length(route); i++) {
    var _p = pathgrid_centre(nav, route[i].col, route[i].row);
    draw_circle(_p.x, _p.y, 6, false);
}
draw_set_colour(c_white);
