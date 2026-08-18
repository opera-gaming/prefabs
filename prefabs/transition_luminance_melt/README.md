# Transition Luminance Melt

A melt room transition — the outgoing room dissolves into the incoming one along
a noisy advancing front, driven by pixel luminance. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_luminance_melt::goto(rm_next);                            // default melt
::transition_luminance_melt::goto(rm_next, 1.5, { threshold: 0.5 }); // tune the luminance cutoff
```

The `up` (melt direction) and `above` (melt above vs. below the luminance
threshold) parameters are baked into the shader.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The luminance-melt effect is adapted from the MIT-licensed
  [`luminance_melt.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/luminance_melt.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
