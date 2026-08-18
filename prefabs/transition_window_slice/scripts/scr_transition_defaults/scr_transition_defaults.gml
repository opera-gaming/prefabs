/// @function transition_defaults()
/// @description Tunable knobs for the window-slice transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { count: 20 }).
function transition_defaults() {
    return {
        count:      10.0,   // number of slices
        smoothness:  0.5,   // slice edge softness
    };
}
