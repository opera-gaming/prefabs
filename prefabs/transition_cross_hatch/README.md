# Transition Cross Hatch

A cross-hatch room transition — a randomised hatch dissolve radiates from a
centre point, revealing the incoming room. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_cross_hatch::goto(rm_next);                           // default hatch
::transition_cross_hatch::goto(rm_next, 1.5, { threshold: 3.0 }); // tune the spread
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The cross-hatch effect is adapted from the MIT-licensed
  [`crosshatch.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/crosshatch.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
