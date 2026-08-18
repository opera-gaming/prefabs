# Transition Grid Flip

A grid room transition — the screen breaks into a grid of tiles separated by
dividers; each tile flips (horizontal squeeze) to swap the outgoing room for the
incoming one. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_grid_flip::goto(rm_next);                          // baked defaults
::transition_grid_flip::goto(rm_next, 1.0, {
    pause: 0.15,          // hold before/after the flip (default 0.1)
    divider_width: 0.08,  // gap between tiles (default 0.05)
    randomness: 0.2       // per-tile timing jitter (default 0.1)
});
```

The grid dimensions (4×4) and background colour (opaque black) are baked into
the shader.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The grid-flip effect is adapted from the MIT-licensed
  [`GridFlip.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GridFlip.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
