/// @function transition_defaults()
/// @description Tunable knobs for the color-distance transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { power: 3 }).
function transition_defaults() {
    return {
        power: 5.0,   // fade easing exponent
    };
}
