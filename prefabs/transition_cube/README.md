# Transition Cube

A rotating-cube room transition — the outgoing and incoming rooms are mapped
onto two faces of a spinning 3D cube, with an optional floor reflection. Derived
from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_cube::goto(rm_next);                                     // default cube
::transition_cube::goto(rm_next, 1.5, { persp: 0.9, reflection: 0.2 });
```

Tunable uniforms: `persp` (perspective, default 0.7), `unzoom`
(zoom-out, default 0.3), `reflection` (floor reflection, default 0.4),
`floating` (float height, default 3.0).

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The cube effect is adapted from the MIT-licensed
  [`cube.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/cube.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
