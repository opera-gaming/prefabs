# Transition Undulating Burnout

An undulating burn-out room transition — a wavy radial burn sweeps outward from
the centre, edged with a burn colour, to reveal the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_undulating_burnout::goto(rm_next);                          // default burn
::transition_undulating_burnout::goto(rm_next, 1.5, { smoothness: 0.1 }); // softer edge
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The undulating burn-out effect is adapted from the MIT-licensed
  [`undulatingBurnOut.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/undulatingBurnOut.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
