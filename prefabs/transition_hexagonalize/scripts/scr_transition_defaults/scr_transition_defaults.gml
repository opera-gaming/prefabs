/// @function transition_defaults()
/// @description Tunable knobs for the hexagonalize transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { steps: 50 }).
function transition_defaults() {
    return {
        steps:               50.0,   // quantisation steps
        horizontal_hexagons: 20.0,   // hexagons across
    };
}
