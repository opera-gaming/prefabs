var _cfg = camera3d_basics_tuning();
var _p = ::kernel::kernel_pointer();

if (mouse_check_button_pressed(mb_right)) { dragging = true; last = _p; }
if (!mouse_check_button(mb_right)) dragging = false;
if (dragging) {
    cam = ::camera3d::camera3d_orbit(cam, _p.x - last.x, _p.y - last.y);
    last = _p;
}

cam.distance = clamp(
    cam.distance - (mouse_wheel_up() - mouse_wheel_down()) * 40,
    _cfg.min_distance, _cfg.max_distance);

// The ray is built from the same basis the draw below projects with, so
// what you click is what you see.
var _ray = ::camera3d::camera3d_ray(cam, _p.x, _p.y,
    ::kernel::kernel_gui_width(), ::kernel::kernel_gui_height());
var _best = -1;
picked = -1;
for (var i = 0; i < array_length(things); i++) {
    var _t = ::camera3d::camera3d_hit_sphere(_ray, things[i].pos, things[i].r);
    if (_t >= 0 && (_best < 0 || _t < _best)) { _best = _t; picked = i; }
}
