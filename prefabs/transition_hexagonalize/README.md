# Transition Hexagonalize

A hexagon room transition — the outgoing room dissolves into a grid of hexagonal
cells that grow toward the midpoint, then resolve back into the incoming room.
Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_hexagonalize::goto(rm_next);                       // baked defaults
::transition_hexagonalize::goto(rm_next, 1.0, {
    steps: 50,                 // quantisation steps (default 50)
    horizontal_hexagons: 20    // hexagons across (default 20)
});
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The hexagonalize effect is adapted from the MIT-licensed
  [`hexagonalize.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/hexagonalize.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
