/// @function transition_defaults()
/// @description Tunable knobs for the linear-blur transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { intensity: 0.2 }).
function transition_defaults() {
    return {
        intensity: 0.1,   // blur strength
    };
}
