# Transition Mosaic

A mosaic room transition — the frame shatters into randomly rotating tiles that
travel across a grid before settling on the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_mosaic::goto(rm_next);   // default mosaic
```

The grid destination (`endx`, `endy`) is baked into the shader.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The mosaic effect is adapted from the MIT-licensed
  [`Mosaic.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Mosaic.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
