/// @function transition_defaults()
/// @description Tunable knobs for the dreamy-zoom transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { rotation: 6 }).
function transition_defaults() {
    return {
        rotation: 6.0,   // spin amount in degrees
        scale:    1.2,   // zoom multiplier
    };
}
