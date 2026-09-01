/// @function camera3d_rotate_vector(v, axis, degrees)
/// @description Rodrigues rotation of `v` about a unit `axis`.
function camera3d_rotate_vector(v, axis, degrees) {
    var _a = degtorad(degrees);
    var _c = cos(_a);
    var _s = sin(_a);
    var _dot = v.x * axis.x + v.y * axis.y + v.z * axis.z;
    return {
        x: v.x * _c + (axis.y * v.z - axis.z * v.y) * _s + axis.x * _dot * (1 - _c),
        y: v.y * _c + (axis.z * v.x - axis.x * v.z) * _s + axis.y * _dot * (1 - _c),
        z: v.z * _c + (axis.x * v.y - axis.y * v.x) * _s + axis.z * _dot * (1 - _c)
    };
}

/// @function camera3d_normalise(v)
function camera3d_normalise(v) {
    var _l = sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    if (_l == 0) return { x: 0, y: 0, z: 0 };
    return { x: v.x / _l, y: v.y / _l, z: v.z / _l };
}

/// @function camera3d_cross(a, b)
/// @description a × b. Operand order is the footgun in this whole file:
/// swapping it flips the right vector, and at screen centre the error
/// has a zero coefficient — so it looks perfect until you click
/// off-centre. Always test picking away from the middle.
function camera3d_cross(a, b) {
    return {
        x: a.y * b.z - a.z * b.y,
        y: a.z * b.x - a.x * b.z,
        z: a.x * b.y - a.y * b.x
    };
}

