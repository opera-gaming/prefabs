/// @function timer_seconds(state)
/// @description Seconds remaining on a countdown, or elapsed on a stopwatch.
function timer_seconds(state) {
    return state.left;
}

/// @function timer_done(state)
/// @description True once a countdown has reached zero. Always false for a
/// stopwatch, which has no end to reach.
function timer_done(state) {
    return !state.up && state.left <= 0;
}

/// @function timer_fraction(state)
/// @description How much of a countdown is left, 0..1, for a bar. Zero for a
/// stopwatch, which has no span to be a fraction of.
function timer_fraction(state) {
    if (state.up || state.span <= 0) return 0;
    return state.left / state.span;
}

