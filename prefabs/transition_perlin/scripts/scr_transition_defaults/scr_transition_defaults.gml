/// @function transition_defaults()
/// @description Tunable knobs for the perlin transition (see fragment.fsh).
/// Override any of these via goto()'s params, e.g. goto(rm, 1.0, { scale: 8.0 }).
function transition_defaults() {
    return {
        scale:       4.0,       // noise field frequency
        smoothness:  0.01,      // edge softness of the dissolve front
        seed:       12.9898,    // random seed for the noise
    };
}
