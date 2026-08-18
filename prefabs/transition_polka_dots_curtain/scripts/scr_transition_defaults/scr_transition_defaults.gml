/// @function transition_defaults()
/// @description Tunable knobs for the polka-dots-curtain transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { dots: 30.0 }).
function transition_defaults() {
    return {
        dots: 20.0,   // number of dots across the grid
    };
}
