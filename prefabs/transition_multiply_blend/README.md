# Transition Multiply Blend

A multiply-blend room transition — the outgoing and incoming rooms are darkened
through one another at the midpoint before resolving to the next room. Derived
from **transition-base**: it overrides only `shaders/sh_transition/fragment.fsh`
and inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_multiply_blend::goto(rm_next);   // no tunable params
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The multiply-blend effect is adapted from the MIT-licensed
  [`multiply_blend.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/multiply_blend.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
