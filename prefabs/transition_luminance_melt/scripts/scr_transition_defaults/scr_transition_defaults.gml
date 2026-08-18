/// @function transition_defaults()
/// @description Tunable knobs for the luminance-melt transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { threshold: 0.5 }).
function transition_defaults() {
    return {
        threshold: 0.8,   // luminance cutoff for the melt
    };
}
