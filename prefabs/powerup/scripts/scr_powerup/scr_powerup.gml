/// Temporary changes to how the game plays.
///
/// The rule that matters is what a second pickup of the same thing does
/// while the first is still running. Refreshing, extending and stacking are
/// three different games, and picking one by accident is how a power-up
/// ends up either useless or permanent.

/// @function powerup_make()
/// @description An empty set of active effects.
function powerup_make() {
    return { active: {} };
}

/// @function powerup_grant(state, name, seconds, mode)
/// @description Start or renew `name` for `seconds`. `mode` decides what a
/// repeat pickup does: "refresh" resets the clock, "extend" adds to it,
/// "stack" adds a level and resets the clock.
function powerup_grant(state, name, seconds, mode) {
    if (!variable_struct_exists(state.active, name)) {
        state.active[$ name] = { left: seconds, span: seconds, level: 1 };
        return 1;
    }
    var _e = state.active[$ name];
    switch (mode) {
        case "extend":
            _e.left += seconds;
            _e.span = max(_e.span, _e.left);
            break;
        case "stack":
            _e.level += 1;
            _e.left = seconds;
            _e.span = seconds;
            break;
        default:
            _e.left = seconds;
            _e.span = seconds;
    }
    return _e.level;
}

/// @function powerup_step(state)
/// @description Age every effect and drop the expired ones. Returns an array
/// of the names that ended this frame, so a caller can undo each exactly
/// once rather than checking for absence every frame.
function powerup_step(state) {
    var _dt = delta_time / 1000000;
    var _ended = [];
    var _names = variable_struct_get_names(state.active);
    for (var i = 0; i < array_length(_names); i++) {
        var _n = _names[i];
        var _e = state.active[$ _n];
        _e.left -= _dt;
        if (_e.left <= 0) {
            array_push(_ended, _n);
            variable_struct_remove(state.active, _n);
        }
    }
    return _ended;
}

/// @function powerup_clear(state)
/// @description End everything at once. A new run, or a death that should
/// cost the player what they were carrying.
function powerup_clear(state) {
    state.active = {};
}
