/// @function transition_defaults()
/// @description Tunable knobs for the doom transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { amplitude: 3 }).
function transition_defaults() {
    return {
        amplitude:  2.0,   // per-bar speed variation
        frequency:  0.5,   // horizontal wave frequency
    };
}
