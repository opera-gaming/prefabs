# Transition Dreamy

A dreamy room transition — a gentle, wavy displacement crossfade between the
outgoing and incoming rooms. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_dreamy::goto(rm_next);            // default (no extra params)
::transition_dreamy::goto(rm_next, 1.5);       // slower crossfade
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The dreamy effect is adapted from the MIT-licensed
  [`Dreamy.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Dreamy.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
