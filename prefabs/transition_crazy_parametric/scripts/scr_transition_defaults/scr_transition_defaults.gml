/// @function transition_defaults()
/// @description Tunable knobs for the crazy-parametric transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { a: 4 }).
function transition_defaults() {
    return {
        a:            4.0,   // parametric coefficient a
        b:            1.0,   // parametric coefficient b
        amplitude:  120.0,   // wobble strength
        smoothness:   0.1,   // offset softening
    };
}
