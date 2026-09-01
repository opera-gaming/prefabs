/// @function health_dead(state)
function health_dead(state) {
    return state.hp <= 0;
}

/// @function health_invulnerable(state)
/// @description True while the window from the last hit is still open.
/// Flashing the sprite on this is what tells a player why they are not
/// taking damage.
function health_invulnerable(state) {
    return state.iframes > 0;
}

/// @function health_fraction(state)
/// @description Remaining health as 0..1, for a bar.
function health_fraction(state) {
    return state.hp / state.max;
}

