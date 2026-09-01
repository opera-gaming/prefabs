draw_text(40, 30, "pathgrid demo — move the mouse; the route goes round the wall");
draw_text(40, 50, array_length(route) > 0
    ? string(array_length(route)) + " steps"
    : "no route (target is inside a wall)");
