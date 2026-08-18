/// @function transition_defaults()
/// @description Tunable knobs for the pinwheel transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { speed: 3.0 }).
function transition_defaults() {
    return {
        speed: 2.0,   // rotation speed of the wedge sweep
    };
}
