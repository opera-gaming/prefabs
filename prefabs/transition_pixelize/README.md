# Transition Pixelize

A pixelize room transition — the outgoing and incoming rooms dissolve through a
growing-then-shrinking mosaic of square blocks. Derived from **transition-base**:
it overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto`
API, the transition machinery, and the demo.

## Usage

```gml
::transition_pixelize::goto(rm_next);   // pixelated dissolve
```

The mosaic resolution (`squaresMin`) and step count (`steps`) are baked defaults
and not exposed as tunable params.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The pixelize effect is adapted from the MIT-licensed
  [`pixelize.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/pixelize.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
