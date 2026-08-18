# Transition Glitch Displace

A glitch / displacement room transition — the outgoing and incoming rooms are
warped by a voronoi displacement field with a brief desaturated flash before
resolving. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_glitch_displace::goto(rm_next);   // no tunable params
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The glitch-displace effect is adapted from the MIT-licensed
  [`GlitchDisplace.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchDisplace.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
