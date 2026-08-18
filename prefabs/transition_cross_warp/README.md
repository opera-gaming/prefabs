# Transition Cross Warp

A cross-warp room transition — both the outgoing and incoming rooms warp and
dissolve into each other across a diagonal sweep. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_cross_warp::goto(rm_next);   // no extra params
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The cross-warp effect is adapted from the MIT-licensed
  [`crosswarp.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/crosswarp.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
