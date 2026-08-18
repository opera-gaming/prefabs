/// @function transition_defaults()
/// @description Tunable knobs for the angular transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { starting_angle: 180 }).
function transition_defaults() {
    return {
        starting_angle: 90.0,   // sweep start angle, in degrees
    };
}
