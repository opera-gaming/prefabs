# Transition Squares Wire

A squares-wire room transition — a diagonal wipe that dissolves the outgoing
room into the incoming room through a grid of growing squares. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_squares_wire::goto(rm_next);                            // default sweep
::transition_squares_wire::goto(rm_next, 1.5, { smoothness: 1.0 }); // tune the edge softness
```

Tunable params: `smoothness` (default 1.6).

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The squares-wire effect is adapted from the MIT-licensed
  [`squareswire.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/squareswire.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
