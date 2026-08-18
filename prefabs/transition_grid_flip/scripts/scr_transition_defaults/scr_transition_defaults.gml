/// @function transition_defaults()
/// @description Tunable knobs for the grid-flip transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { pause: 0.1 }).
function transition_defaults() {
    return {
        pause:         0.1,    // hold before/after the flip
        divider_width: 0.05,   // gap between tiles
        randomness:    0.1,    // per-tile timing jitter
    };
}
