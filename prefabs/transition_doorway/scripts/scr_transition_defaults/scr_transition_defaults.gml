/// @function transition_defaults()
/// @description Tunable knobs for the doorway transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { reflection: 0.4 }).
function transition_defaults() {
    return {
        reflection:   0.4,   // floor reflection strength
        perspective:  0.4,   // perspective amount
        depth:        3.0,   // door recede depth
    };
}
