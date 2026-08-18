/// @function transition_defaults()
/// @description Tunable knobs for the simple-zoom transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { zoom_quickness: 0.5 }).
function transition_defaults() {
    return {
        zoom_quickness: 0.8,   // zoom timing (clamped to 0.2..1.0)
    };
}
