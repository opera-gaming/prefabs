/// @function transition_defaults()
/// @description Tunable knobs for the wind transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { size: 0.4 }).
function transition_defaults() {
    return {
        size: 0.2,   // streak width
    };
}
