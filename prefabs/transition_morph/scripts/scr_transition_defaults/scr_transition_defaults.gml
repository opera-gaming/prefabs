/// @function transition_defaults()
/// @description Tunable knobs for the morph transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { strength: 0.2 }).
function transition_defaults() {
    return {
        strength: 0.1,   // warp strength
    };
}
