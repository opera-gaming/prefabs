# Transition Fly Eye

A fly-eye room transition — a rippling lens displacement with chromatic
separation that dissolves the outgoing room into the incoming one. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_flye_eye::goto(rm_next);                            // default
::transition_flye_eye::goto(rm_next, 1.5, {                      // tune the lens
    size: 0.04, zoom: 50.0, color_separation: 0.3 });
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The fly-eye effect is adapted from the MIT-licensed
  [`flyeye.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/flyeye.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
