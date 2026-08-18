# Transition Bounce

A bounce room transition — the outgoing room drops down and bounces away,
casting a soft shadow, to reveal the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_bounce::goto(rm_next);                                            // default (3 bounces)
::transition_bounce::goto(rm_next, 1.5, { bounces: 4.0, shadow_height: 0.1 });
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The bounce effect is adapted from the MIT-licensed
  [`Bounce.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Bounce.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
