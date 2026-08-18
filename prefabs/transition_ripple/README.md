# Transition Ripple

A ripple room transition — a water-like wave radiates from the centre, distorting
the outgoing room as it fades into the incoming one. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_ripple::goto(rm_next);                                             // default ripple
::transition_ripple::goto(rm_next, 1.5, { amplitude: 100.0, speed: 50.0 }); // tune the wave
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The ripple effect is adapted from the MIT-licensed
  [`ripple.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ripple.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
