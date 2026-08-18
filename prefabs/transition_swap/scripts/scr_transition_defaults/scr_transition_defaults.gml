/// @function transition_defaults()
/// @description Tunable knobs for the swap transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { reflection: 0.5 }).
function transition_defaults() {
    return {
        reflection:  0.4,   // floor reflection strength
        perspective: 0.2,   // perspective skew
        depth:       3.0,   // how far rooms recede
    };
}
