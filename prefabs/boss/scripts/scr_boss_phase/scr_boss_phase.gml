/// @function boss_phase_for(state, fraction)
/// @description Which stage a health fraction falls in, counting from 1.
function boss_phase_for(state, fraction) {
    var _p = state.phases - floor(clamp(fraction, 0, 0.999) * state.phases);
    return clamp(_p, 1, state.phases);
}

/// @function boss_ready(state)
/// @description Whether the boss is free to start something — not already
/// winding up, attacking, or recovering.
function boss_ready(state) {
    return state.telegraph <= 0 && state.active <= 0 && state.cooldown <= 0
        && !boss_dead(state);
}

/// @function boss_begin(state, move, telegraph_seconds, active_seconds, recover_seconds)
/// @description Start an attack: wind up for `telegraph_seconds`, then
/// `boss_step` returns "telegraph_end" and you fire it, then it runs for
/// `active_seconds`, then the boss recovers for `recover_seconds`.
///
/// The recovery is the player's turn. A boss with none is a boss you cannot
/// approach.
function boss_begin(state, move, telegraph_seconds, active_seconds, recover_seconds) {
    if (!boss_ready(state)) return false;
    state.move = move;
    state.telegraph = telegraph_seconds;
    state.telegraph_span = max(0.0001, telegraph_seconds);
    state.active = active_seconds;
    state.cooldown = recover_seconds;
    return true;
}

/// @function boss_telegraphing(state)
function boss_telegraphing(state) {
    return state.telegraph > 0;
}

/// @function boss_telegraph_fraction(state)
/// @description How far through the wind-up, 0..1. Drive a flash, a growing
/// marker or a sound pitch off this so the player can time the dodge rather
/// than guess it.
function boss_telegraph_fraction(state) {
    if (state.telegraph <= 0) return 0;
    return 1 - state.telegraph / state.telegraph_span;
}

/// @function boss_attacking(state)
function boss_attacking(state) {
    return state.active > 0;
}

