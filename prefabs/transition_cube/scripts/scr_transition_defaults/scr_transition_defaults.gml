/// @function transition_defaults()
/// @description Tunable knobs for the cube transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { persp: 0.9 }).
function transition_defaults() {
    return {
        persp:       0.7,   // perspective amount
        unzoom:      0.3,   // zoom-out amount
        reflection:  0.4,   // floor reflection strength
        floating:    3.0,   // float height
    };
}
