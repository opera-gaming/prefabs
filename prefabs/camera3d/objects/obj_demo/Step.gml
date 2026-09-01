var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_right)) { dragging = true; last = { x: _mx, y: _my }; }
if (!mouse_check_button(mb_right)) dragging = false;
if (dragging) {
    cam = camera3d_orbit(cam, _mx - last.x, _my - last.y);
    last = { x: _mx, y: _my };
}

cam.distance = clamp(cam.distance - (mouse_wheel_up() - mouse_wheel_down()) * 40, 120, 900);

// Pick through the SAME basis the drawing below uses.
var _ray = camera3d_ray(cam, _mx, _my, display_get_gui_width(), display_get_gui_height());
var _best = -1;
var _which = -1;
for (var i = 0; i < array_length(balls); i++) {
    balls[i].hit = false;
    var _t = camera3d_hit_sphere(_ray, balls[i].pos, balls[i].r);
    if (_t >= 0 && (_best < 0 || _t < _best)) { _best = _t; _which = i; }
}
if (_which >= 0) balls[_which].hit = true;
