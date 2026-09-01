cell = 40;
nav = pathgrid_make(24, 13, cell);

// A wall with one gap, so the route has to go round rather than through.
for (var r = 2; r < 11; r++) {
    if (r == 6) continue;
    pathgrid_block(nav, 11, r, true);
    instance_create_depth(11 * cell + cell / 2, r * cell + cell / 2, 0, obj_demo_wall);
}
route = [];
