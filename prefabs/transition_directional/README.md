# Transition Directional

A directional slide room transition — the outgoing room slides off-screen in a
fixed direction while the incoming room slides in behind it. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_directional::goto(rm_next);   // slides horizontally
```

The slide direction is baked to `[1, 0]` (rightward). Re-author the shader's
`direction` constant to change it.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The directional effect is adapted from the MIT-licensed
  [`Directional.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Directional.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
