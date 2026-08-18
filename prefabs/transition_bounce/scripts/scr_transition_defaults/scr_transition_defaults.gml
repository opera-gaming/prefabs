/// @function transition_defaults()
/// @description Tunable knobs for the bounce transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { shadow_height: 0.1 }).
function transition_defaults() {
    return {
        shadow_height: 0.075,   // height of the drop shadow
        bounces:       3.0,     // number of bounces
    };
}
