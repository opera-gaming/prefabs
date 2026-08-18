# Transition Polar Function

A polar-function room transition — a scalloped, flower/petal-shaped radial region
grows from the centre to reveal the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_polar_function::goto(rm_next);   // petal-shaped radial reveal
```

The petal count (`segments`) is a baked default and not exposed as a tunable param.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The polar-function effect is adapted from the MIT-licensed
  [`polar_function.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/polar_function.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
