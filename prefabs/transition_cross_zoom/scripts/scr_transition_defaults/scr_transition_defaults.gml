/// @function transition_defaults()
/// @description Tunable knobs for the cross-zoom transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { strength: 0.6 }).
function transition_defaults() {
    return {
        strength:  0.4,   // zoom blur strength
    };
}
