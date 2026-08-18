# Transition Heart

A heart-shaped room transition — a heart-shaped wipe grows from the centre of
the screen to reveal the incoming room. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_heart::goto(rm_next);   // no tunable params
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The heart effect is adapted from the MIT-licensed
  [`heart.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/heart.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
