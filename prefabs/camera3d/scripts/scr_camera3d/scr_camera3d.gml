/// A trackball orbit camera.
///
/// State is two vectors — a direction and an up — not a yaw/pitch pair.
/// Euler angles gimbal-lock at the poles and make "rotate around the
/// camera's CURRENT axes" awkward; two vectors rotate around whatever
/// axis you hand them and never lock.
///
/// The basis is exposed because the renderer and the picker must use the
/// SAME one. `matrix_build_lookat` silently re-orthogonalises what you
/// give it, so a camera with a subtly wrong basis still LOOKS correct
/// and then throws the pick ray somewhere else entirely.

/// @function camera3d_make(distance, fov)
function camera3d_make(distance = 400, fov = 60) {
    return {
        target: { x: 0, y: 0, z: 0 },
        dir: { x: 0, y: -1, z: 0 },   // from target toward the camera
        up: { x: 0, y: 0, z: 1 },
        distance: distance,
        fov: fov
    };
}

/// @function camera3d_basis(cam)
/// @description The orthonormal {forward, right, up} the camera is
/// actually looking along. Both rendering and picking read this.
function camera3d_basis(cam) {
    var _fwd = camera3d_normalise({ x: -cam.dir.x, y: -cam.dir.y, z: -cam.dir.z });
    var _right = camera3d_normalise(camera3d_cross(_fwd, cam.up));
    // Re-derive up from the other two so the basis is orthonormal even
    // after many incremental drags have accumulated float error.
    var _up = camera3d_cross(_right, _fwd);
    return { forward: _fwd, right: _right, up: _up };
}

/// @function camera3d_position(cam)
function camera3d_position(cam) {
    return {
        x: cam.target.x + cam.dir.x * cam.distance,
        y: cam.target.y + cam.dir.y * cam.distance,
        z: cam.target.z + cam.dir.z * cam.distance
    };
}

/// @function camera3d_orbit(cam, dx, dy)
/// @description Drag by screen pixels. Yaw turns about the camera's own
/// up, pitch about its own right — which is what "trackball" means and
/// why this needs no pole clamp.
function camera3d_orbit(cam, dx, dy) {
    var _b = camera3d_basis(cam);
    cam.dir = camera3d_normalise(camera3d_rotate_vector(cam.dir, _b.up, -dx * 0.4));
    cam.up = camera3d_normalise(camera3d_rotate_vector(cam.up, _b.up, -dx * 0.4));
    var _b2 = camera3d_basis(cam);
    cam.dir = camera3d_normalise(camera3d_rotate_vector(cam.dir, _b2.right, -dy * 0.4));
    cam.up = camera3d_normalise(camera3d_rotate_vector(cam.up, _b2.right, -dy * 0.4));
    return cam;
}

