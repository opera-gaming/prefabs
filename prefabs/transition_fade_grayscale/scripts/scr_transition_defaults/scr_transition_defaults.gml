/// @function transition_defaults()
/// @description Tunable knobs for the fade-grayscale transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { intensity: 0.3 }).
function transition_defaults() {
    return {
        intensity: 0.3,   // fraction of progress held desaturated
    };
}
