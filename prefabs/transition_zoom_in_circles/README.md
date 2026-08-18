# Transition Zoom In Circles

A zoom-in-circles room transition — concentric rings zoom inward, warping the
outgoing room before snapping to the incoming one. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_zoom_in_circles::goto(rm_next);       // default zoom
::transition_zoom_in_circles::goto(rm_next, 1.5);  // slower zoom
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The zoom-in-circles effect is adapted from the MIT-licensed
  [`ZoomInCircles.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ZoomInCircles.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
