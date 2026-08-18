# Transition Rotate Scale Fade

A rotate-scale-fade room transition — spins and zooms the frame while
cross-fading between the outgoing and incoming rooms, over a neutral back
colour. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_rotate_scale_face::goto(rm_next);                                  // default spin
::transition_rotate_scale_face::goto(rm_next, 1.5, { rotations: 2.0, scale: 6.0 }); // tune it
```

Tunable params: `rotations` (default 1.0), `scale` (default 8.0).

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The rotate-scale-fade effect is adapted from the MIT-licensed
  [`rotate_scale_fade.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/rotate_scale_fade.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
