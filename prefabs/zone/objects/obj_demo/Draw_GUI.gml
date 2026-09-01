draw_text(40, 30, "zone demo — move the mouse in and out; SPACE forgets what was inside");
draw_text(40, 60, "distance to the door: "
    + string(round(zone_nearest_edge(door, mouse_x, mouse_y))));
for (var i = 0; i < array_length(log_lines); i++) {
    draw_text(700, 60 + i * 20, log_lines[i]);
}
