/// Darkness with holes cut in it.
///
/// A surface filled with night, then lights subtracted from it. The whole
/// technique rests on one fact that bites everyone once: **a surface is
/// volatile**. The OS can free it whenever the window resizes, the display
/// sleeps, or memory gets tight, and the next frame that draws to a freed
/// surface draws nothing — a game that looks perfect until it does not, in
/// a way no test catches because it depends on the machine.
///
/// So every function here re-checks `surface_exists` and rebuilds. Never
/// hold a surface across frames without that check.

/// @function light_make(darkness, colour)
/// @description Lighting state. `darkness` is 0..1 — how black the unlit
/// parts are — and `colour` tints the night (a deep blue reads better than
/// pure black almost everywhere).
function light_make(darkness, colour) {
    return { surf: -1, dark: clamp(darkness, 0, 1), tint: colour, lights: [] };
}

/// @function light_add(state, x, y, radius, strength)
/// @description Queue a light for this frame. Cleared by `light_draw`, so
/// lights are declared every frame by whatever owns them — a torch adds its
/// own, and stops adding it the moment it is destroyed.
function light_add(state, x, y, radius, strength) {
    array_push(state.lights, {
        x: x, y: y, r: max(1, radius), s: clamp(strength, 0, 1),
    });
}

/// @function light_add_cone(state, x, y, radius, direction, spread, strength)
/// @description A light that only reaches one way — a torch, a headlamp.
/// Approximated as overlapping circles along the facing, which is cheaper
/// than a real cone and indistinguishable once it is blurred by the falloff.
function light_add_cone(state, x, y, radius, direction, spread, strength) {
    var _steps = 4;
    for (var i = 0; i < _steps; i++) {
        var _t = (i + 1) / _steps;
        var _d = radius * _t;
        light_add(state,
            x + lengthdir_x(_d * 0.6, direction),
            y + lengthdir_y(_d * 0.6, direction),
            radius * (0.35 + spread / 180 * _t), strength);
    }
}

/// @function light_free(state)
/// @description Release the surface. Call in Cleanup — a surface left
/// behind on every room change is a leak the game only notices an hour in.
function light_free(state) {
    if (surface_exists(state.surf)) surface_free(state.surf);
    state.surf = -1;
}

