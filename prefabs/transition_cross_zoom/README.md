# Transition Cross Zoom

A cross-zoom room transition — a blurred zoom-and-dissolve that rushes toward a
moving center as it swaps the outgoing and incoming rooms. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_cross_zoom::goto(rm_next);                          // default blur
::transition_cross_zoom::goto(rm_next, 1.5, { strength: 0.6 }); // tune the zoom blur
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The cross-zoom effect is adapted from the MIT-licensed
  [`CrossZoom.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CrossZoom.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
