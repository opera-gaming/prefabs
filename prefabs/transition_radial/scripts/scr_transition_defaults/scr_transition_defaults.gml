/// @function transition_defaults()
/// @description Tunable knobs for the radial transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { smoothness: 0.5 }).
function transition_defaults() {
    return {
        smoothness: 1.0,   // sweep edge softness
    };
}
