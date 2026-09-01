/// @function powerup_has(state, name)
function powerup_has(state, name) {
    return variable_struct_exists(state.active, name);
}

/// @function powerup_level(state, name)
/// @description How many are stacked, or 0 when it is not running — so a
/// multiplier can be `1 + powerup_level(...) * 0.5` with no branch.
function powerup_level(state, name) {
    if (!powerup_has(state, name)) return 0;
    return state.active[$ name].level;
}

/// @function powerup_seconds(state, name)
function powerup_seconds(state, name) {
    if (!powerup_has(state, name)) return 0;
    return state.active[$ name].left;
}

/// @function powerup_fraction(state, name)
/// @description How much of the effect is left, 0..1, for a pip or a ring.
function powerup_fraction(state, name) {
    if (!powerup_has(state, name)) return 0;
    var _e = state.active[$ name];
    return _e.span <= 0 ? 0 : clamp(_e.left / _e.span, 0, 1);
}

/// @function powerup_names(state)
/// @description Every running effect, for drawing the row of icons.
function powerup_names(state) {
    return variable_struct_get_names(state.active);
}

