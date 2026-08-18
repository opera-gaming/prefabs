# Transition Color Phase

A colour-phase room transition — the outgoing and incoming rooms blend per
colour channel across staggered phase thresholds, so the channels cross over at
slightly different times. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_color_phase::goto(rm_next);      // default phase steps
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The colour-phase effect is adapted from the MIT-licensed
  [`colorphase.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/colorphase.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
