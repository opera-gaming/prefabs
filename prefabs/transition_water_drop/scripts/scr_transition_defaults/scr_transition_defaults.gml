/// @function transition_defaults()
/// @description Tunable knobs for the water-drop transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { amplitude: 50 }).
function transition_defaults() {
    return {
        amplitude: 30.0,   // ripple distortion strength
        speed:     30.0,   // ripple travel speed
    };
}
