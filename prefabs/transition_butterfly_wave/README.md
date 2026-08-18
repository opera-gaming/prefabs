# Transition Butterfly Wave

A butterfly-wave room transition — a rippling warp driven by a butterfly polar
curve, with a chromatic (RGB) separation, blending the outgoing and incoming
rooms. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_butterfly_wave::goto(rm_next);                                                 // default
::transition_butterfly_wave::goto(rm_next, 1.5, { waves: 20.0, color_separation: 0.5 });// tune it
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The butterfly-wave effect is adapted from the MIT-licensed
  [`ButterflyWaveScrawler.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ButterflyWaveScrawler.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
