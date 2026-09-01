draw_self();
// The deadzone, so what the camera is doing is visible rather than felt.
draw_set_colour(#3A4152);
var _cx = cam.x + cam.view_w * 0.5, _cy = cam.y + cam.view_h * 0.5;
draw_rectangle(
    _cx - cam.deadzone_x, _cy - cam.deadzone_y,
    _cx + cam.deadzone_x, _cy + cam.deadzone_y, true
);
draw_set_colour(c_white);
