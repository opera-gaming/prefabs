/// Countdowns, stopwatches, and turning seconds into something readable.
///
/// In seconds rather than frames throughout. A game written in frames reads
/// fine until someone changes the room speed, and then every duration in it
/// is wrong at once.

/// @function timer_countdown(seconds)
/// @description A timer counting down from `seconds`, already running.
function timer_countdown(seconds) {
    return { left: seconds, span: seconds, up: false, running: true };
}

/// @function timer_stopwatch()
/// @description A timer counting up from zero, already running.
function timer_stopwatch() {
    return { left: 0, span: 0, up: true, running: true };
}

/// @function timer_step(state)
/// @description Advance one frame. Returns true on the single frame a
/// countdown reaches zero, so the caller can end the round there rather than
/// testing for zero every frame afterwards and ending it repeatedly.
function timer_step(state) {
    if (!state.running) return false;
    var _dt = delta_time / 1000000;
    if (state.up) {
        state.left += _dt;
        return false;
    }
    if (state.left <= 0) return false;
    state.left = max(0, state.left - _dt);
    return state.left <= 0;
}

/// @function timer_pause(state, paused)
/// @description Stop or resume it. A paused timer is the difference between
/// a pause menu and a pause menu you can hide in.
function timer_pause(state, paused) {
    state.running = !paused;
}

/// @function timer_add(state, seconds)
/// @description Extend a countdown — a pickup that buys time. Never past
/// the span it started with, so the bar cannot overfill.
function timer_add(state, seconds) {
    state.left = state.up ? state.left + seconds
                          : min(state.span, state.left + seconds);
}

/// @function timer_restart(state, seconds)
/// @description Back to `seconds` and running. Pass a new span to change the
/// length at the same time.
function timer_restart(state, seconds) {
    state.left = state.up ? 0 : seconds;
    state.span = seconds;
    state.running = true;
}

