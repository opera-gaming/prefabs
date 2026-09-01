/// @function light_draw(state)
/// @description Draw the darkness with this frame's lights cut out of it,
/// then clear the queue. Call once, in a Draw event after the world and
/// before the HUD — lighting the score display is rarely what anyone wants.
function light_draw(state) {
    var _w = room_width;
    var _h = room_height;

    // Volatile: rebuild whenever it has gone, which is not rare.
    if (!surface_exists(state.surf)) {
        state.surf = surface_create(_w, _h);
    }

    surface_set_target(state.surf);
    draw_clear_alpha(state.tint, state.dark);

    // Subtractive blending punches the lights out of the night rather than
    // painting light on top of it, which is what keeps the unlit parts fully
    // dark instead of washing everything to grey.
    gpu_set_blendmode(bm_subtract);
    for (var i = 0; i < array_length(state.lights); i++) {
        var _l = state.lights[i];
        light_falloff(_l.x, _l.y, _l.r, _l.s);
    }
    gpu_set_blendmode(bm_normal);
    surface_reset_target();

    draw_surface(state.surf, 0, 0);
    state.lights = [];
}

/// How many rings approximate one light's gradient. More is smoother and
/// costs a draw call each; ten is indistinguishable from twenty at the sizes
/// a light is usually drawn.
#macro LIGHT_FALLOFF_RINGS 10
/// Per-ring alpha. The rings overlap, so this is well below 1 — raising it
/// makes the light's centre blow out to a hard white disc.
#macro LIGHT_FALLOFF_STEP 0.35

/// @function light_falloff(x, y, radius, strength)
/// @description One light's gradient, as rings from the centre out. A hard
/// circle reads as a hole in a sheet of paper; the gradient is what makes it
/// read as light. Shaped by `LIGHT_FALLOFF_RINGS` and `LIGHT_FALLOFF_STEP`.
function light_falloff(x, y, radius, strength) {
    var _rings = LIGHT_FALLOFF_RINGS;
    for (var i = _rings; i >= 1; i--) {
        var _t = i / _rings;
        var _a = strength * (1 - _t) * LIGHT_FALLOFF_STEP;
        draw_set_alpha(_a);
        draw_circle_colour(x, y, radius * _t, c_white, c_white, false);
    }
    draw_set_alpha(1);
}

/// @function light_lit(state, x, y)
/// @description Whether a point is inside any light queued this frame. For
/// gameplay that depends on it — a monster that only moves in the dark —
/// without reading pixels back off the surface, which is far slower.
///
/// Ask before `light_draw`, which clears the queue.
function light_lit(state, x, y) {
    for (var i = 0; i < array_length(state.lights); i++) {
        var _l = state.lights[i];
        if (point_distance(x, y, _l.x, _l.y) <= _l.r) return true;
    }
    return false;
}
