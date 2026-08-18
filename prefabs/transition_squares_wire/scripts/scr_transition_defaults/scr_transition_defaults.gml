/// @function transition_defaults()
/// @description Tunable knobs for the squares-wire transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { smoothness: 1.0 }).
function transition_defaults() {
    return {
        smoothness: 1.6,   // wipe edge softness
    };
}
