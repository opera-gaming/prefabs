/// The difficulty curve: how often things arrive, and how that changes.
///
/// Separate from spawning on purpose. This decides *when* and *how many*;
/// what appears is the game's business, and keeping the two apart is what
/// lets the same curve drive enemies, obstacles or cards.

/// @function wave_make(interval, scale, floor, wave_seconds)
/// @description A curve starting at `interval` seconds between spawns,
/// multiplied by `scale` each wave, never below `floor`, with a new wave
/// every `wave_seconds`. `scale` below 1 gets harder; above 1 gets easier.
function wave_make(interval, scale, floor, wave_seconds) {
    return {
        base: interval,
        scale: scale,
        floor: max(0.016, floor),
        wave_seconds: wave_seconds,
        wave: 1,
        next: interval,
        wave_left: wave_seconds,
        elapsed: 0,
    };
}

/// @function wave_step(state)
/// @description Advance one frame. Returns true on the frames a spawn is
/// due — at most once per frame, so a caller can spawn unconditionally on
/// a true without checking anything else.
function wave_step(state) {
    var _dt = delta_time / 1000000;
    state.elapsed += _dt;

    state.wave_left -= _dt;
    if (state.wave_left <= 0) {
        state.wave += 1;
        state.wave_left += state.wave_seconds;
    }

    state.next -= _dt;
    if (state.next > 0) return false;
    state.next += wave_interval(state);
    return true;
}

/// @function wave_reset(state)
/// @description Back to wave 1. What a new run needs — without it the
/// second run starts at the difficulty the first one ended at.
function wave_reset(state) {
    state.wave = 1;
    state.next = state.base;
    state.wave_left = state.wave_seconds;
    state.elapsed = 0;
}
