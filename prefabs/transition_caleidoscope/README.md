# Transition Caleidoscope

A kaleidoscope room transition — a mirrored, rotating fractal fold that peaks
mid-transition before resolving into the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_caleidoscope::goto(rm_next);                                          // default fold
::transition_caleidoscope::goto(rm_next, 1.5, { speed: 2.0, power: 2.0 });     // tune it
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The kaleidoscope effect is adapted from the MIT-licensed
  [`kaleidoscope.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/kaleidoscope.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
