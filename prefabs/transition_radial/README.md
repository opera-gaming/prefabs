# Transition Radial

A radial room transition — a clock-hand sweep rotates around the centre of the
screen, wiping the outgoing room away to reveal the incoming one. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_radial::goto(rm_next);                              // default sweep
::transition_radial::goto(rm_next, 1.5, { smoothness: 0.5 });  // crisper edge
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The radial effect is adapted from the MIT-licensed
  [`Radial.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Radial.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
