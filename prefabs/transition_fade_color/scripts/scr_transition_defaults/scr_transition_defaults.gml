/// @function transition_defaults()
/// @description Tunable knobs for the fade-color transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { color_phase: 0.4 }).
function transition_defaults() {
    return {
        color_phase: 0.4,   // fraction of progress held at the fade colour
    };
}
