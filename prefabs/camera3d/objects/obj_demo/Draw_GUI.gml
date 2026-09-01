// Project each sphere centre with the same basis the ray used, so a
// mismatch shows up as a marker that misses its own circle.
var _b = camera3d_basis(cam);
var _eye = camera3d_position(cam);
var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _tan = tan(degtorad(cam.fov) / 2);

for (var i = 0; i < array_length(balls); i++) {
    var _p = balls[i].pos;
    var _v = { x: _p.x - _eye.x, y: _p.y - _eye.y, z: _p.z - _eye.z };
    var _z = _v.x * _b.forward.x + _v.y * _b.forward.y + _v.z * _b.forward.z;
    if (_z <= 1) continue;
    var _rx = _v.x * _b.right.x + _v.y * _b.right.y + _v.z * _b.right.z;
    var _ry = _v.x * _b.up.x + _v.y * _b.up.y + _v.z * _b.up.z;

    var _sx = _w / 2 + (_rx / (_z * _tan * (_w / _h))) * (_w / 2);
    var _sy = _h / 2 - (_ry / (_z * _tan)) * (_h / 2);
    var _sr = (balls[i].r / (_z * _tan)) * (_h / 2);

    draw_set_colour(balls[i].hit ? c_yellow : c_aqua);
    draw_circle(_sx, _sy, _sr, true);
}
draw_set_colour(c_white);
draw_text(16, 16, "camera3d demo — right-drag orbits, wheel zooms");
draw_text(16, 36, "hover a sphere: the pick ray uses the same basis as the drawing");
