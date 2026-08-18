# Transition Pinwheel

A pinwheel / clock-wipe room transition — a rotating wedge sweep between the
outgoing and incoming rooms. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_pinwheel::goto(rm_next);                        // default spin
::transition_pinwheel::goto(rm_next, 1.5, { speed: 3.0 }); // tune the spin
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The pinwheel effect is adapted from the MIT-licensed
  [`pinwheel.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/pinwheel.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
