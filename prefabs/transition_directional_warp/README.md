# Transition Directional Warp

A directional-warp room transition — a smooth diagonal wipe that warps each room
toward the sweep line as it crosses the screen. Derived from **transition-base**:
it overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto`
API, the transition machinery, and the demo.

## Usage

```gml
::transition_directional_warp::goto(rm_next);   // diagonal warp wipe
```

The warp direction is baked to `[-1, 1]` (diagonal). Re-author the shader's
`direction` constant to change it.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The directional-warp effect is adapted from the MIT-licensed
  [`directionalwarp.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/directionalwarp.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
