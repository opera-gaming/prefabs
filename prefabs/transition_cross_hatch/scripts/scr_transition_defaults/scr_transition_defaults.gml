/// @function transition_defaults()
/// @description Tunable knobs for the cross-hatch transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { threshold: 3 }).
function transition_defaults() {
    return {
        threshold:  3.0,   // hatch spread distance
        fade_edge:  0.1,   // edge fade softness
    };
}
