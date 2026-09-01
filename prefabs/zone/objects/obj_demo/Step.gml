// One call per zone per frame: `zone_track` advances state, so asking
// twice in a frame would eat the transition.
var _d = zone_track(door, mouse_x, mouse_y);
var _w = zone_track(well, mouse_x, mouse_y);

if (_d == "enter" || _d == "exit") array_push(log_lines, "door " + _d);
if (_w == "enter" || _w == "exit") array_push(log_lines, "well " + _w);
while (array_length(log_lines) > 8) array_delete(log_lines, 0, 1);

if (keyboard_check_pressed(vk_space)) {
    zone_reset(door);
    zone_reset(well);
    array_push(log_lines, "reset");
}
