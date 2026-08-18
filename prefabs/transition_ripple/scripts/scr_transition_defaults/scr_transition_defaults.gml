/// @function transition_defaults()
/// @description Tunable knobs for the ripple transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { amplitude: 60 }).
function transition_defaults() {
    return {
        amplitude: 100.0,   // ripple strength
        speed:      50.0,   // wave travel speed
    };
}
