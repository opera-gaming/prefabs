# Transition Angular

An angular room transition — a radial wipe that sweeps around the center by
angle, revealing the incoming room. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_angular::goto(rm_next);                                  // default sweep (90°)
::transition_angular::goto(rm_next, 1.5, { starting_angle: 180.0 });// tune the start angle
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The angular effect is adapted from the MIT-licensed
  [`angular.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/angular.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
