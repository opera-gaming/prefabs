/// @function wave_interval(state)
/// @description Seconds between spawns at the current wave, floor applied.
function wave_interval(state) {
    return max(state.floor, state.base * power(state.scale, state.wave - 1));
}

/// @function wave_number(state)
/// @description Which wave it is, counting from 1 — the number to show.
function wave_number(state) {
    return state.wave;
}

/// @function wave_progress(state)
/// @description How far through the current wave, 0..1. For a bar, or to
/// hold a boss back until the wave is nearly over.
function wave_progress(state) {
    return 1 - state.wave_left / state.wave_seconds;
}

/// @function wave_budget(state, base_count)
/// @description How many to spawn at once at this wave — `base_count`
/// growing with the wave number. Raising the count as well as the rate is
/// what stops a curve flattening the moment it hits the interval floor.
function wave_budget(state, base_count) {
    return base_count + floor((state.wave - 1) / 3);
}

