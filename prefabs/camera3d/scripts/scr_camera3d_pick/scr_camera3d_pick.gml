/// @function camera3d_ray(cam, gui_x, gui_y, view_w, view_h)
/// @description A world-space ray through a GUI-space point, as
/// {origin, dir}. GUI space, not room space: in a room with a moving
/// view the two differ and the pick silently misses.
function camera3d_ray(cam, gui_x, gui_y, view_w, view_h) {
    var _b = camera3d_basis(cam);
    var _aspect = view_w / max(view_h, 1);
    var _tan = tan(degtorad(cam.fov) / 2);

    // Normalised device coords, +y up.
    var _ndc_x = (gui_x / max(view_w, 1)) * 2 - 1;
    var _ndc_y = 1 - (gui_y / max(view_h, 1)) * 2;

    var _dir = {
        x: _b.forward.x + _b.right.x * _ndc_x * _tan * _aspect + _b.up.x * _ndc_y * _tan,
        y: _b.forward.y + _b.right.y * _ndc_x * _tan * _aspect + _b.up.y * _ndc_y * _tan,
        z: _b.forward.z + _b.right.z * _ndc_x * _tan * _aspect + _b.up.z * _ndc_y * _tan
    };
    return { origin: camera3d_position(cam), dir: camera3d_normalise(_dir) };
}

/// @function camera3d_hit_sphere(ray, centre, radius)
/// @description Distance along `ray` to the near intersection, or -1.
function camera3d_hit_sphere(ray, centre, radius) {
    var _ox = ray.origin.x - centre.x;
    var _oy = ray.origin.y - centre.y;
    var _oz = ray.origin.z - centre.z;
    var _b = 2 * (_ox * ray.dir.x + _oy * ray.dir.y + _oz * ray.dir.z);
    var _c = _ox * _ox + _oy * _oy + _oz * _oz - radius * radius;
    var _disc = _b * _b - 4 * _c;
    if (_disc < 0) return -1;
    var _t = (-_b - sqrt(_disc)) / 2;
    return (_t < 0) ? -1 : _t;
}
