# Transition Linear Blur

A blur room transition — both the outgoing and incoming rooms smear outward
mid-transition while cross-fading. Derived from **transition-base**: it overrides
only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the
transition machinery, and the demo.

## Usage

```gml
::transition_linear_blur::goto(rm_next);                          // default blur
::transition_linear_blur::goto(rm_next, 1.5, { intensity: 0.2 }); // stronger blur
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The linear-blur effect is adapted from the MIT-licensed
  [`LinearBlur.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LinearBlur.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
