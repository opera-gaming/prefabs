/// @function transition_defaults()
/// @description Tunable knobs for the caleidoscope transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { speed: 2 }).
function transition_defaults() {
    return {
        speed: 1.0,   // fold animation speed
        angle: 1.0,   // rotation per fold iteration
        power: 1.5,   // progress easing exponent
    };
}
