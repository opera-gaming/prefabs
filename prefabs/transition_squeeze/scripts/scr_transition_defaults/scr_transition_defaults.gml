/// @function transition_defaults()
/// @description Tunable knobs for the squeeze transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { color_separation: 0.08 }).
function transition_defaults() {
    return {
        color_separation: 0.04,   // chromatic smear amount
    };
}
