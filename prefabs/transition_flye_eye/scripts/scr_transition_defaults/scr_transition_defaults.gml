/// @function transition_defaults()
/// @description Tunable knobs for the fly-eye transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { size: 0.04 }).
function transition_defaults() {
    return {
        size:             0.04,   // lens displacement amount
        zoom:             50.0,   // lens frequency
        color_separation: 0.3,    // chromatic separation strength
    };
}
