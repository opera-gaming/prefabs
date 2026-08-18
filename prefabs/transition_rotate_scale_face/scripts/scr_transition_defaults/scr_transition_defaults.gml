/// @function transition_defaults()
/// @description Tunable knobs for the rotate-scale-fade transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { rotations: 2.0 }).
function transition_defaults() {
    return {
        rotations: 1.0,   // number of full spins
        scale:     8.0,   // peak zoom-out factor
    };
}
