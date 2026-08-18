/// @function transition_defaults()
/// @description Tunable knobs for the butterfly-wave transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { amplitude: 2 }).
function transition_defaults() {
    return {
        amplitude:        1.0,    // wave displacement strength
        waves:            30.0,   // number of waves
        color_separation: 0.3,    // chromatic (RGB) separation
    };
}
