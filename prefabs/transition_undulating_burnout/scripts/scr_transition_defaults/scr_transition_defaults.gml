/// @function transition_defaults()
/// @description Tunable knobs for the undulating-burnout transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { smoothness: 0.1 }).
function transition_defaults() {
    return {
        smoothness: 0.03,   // burn edge softness
    };
}
