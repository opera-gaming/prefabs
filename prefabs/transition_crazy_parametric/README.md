# Transition Crazy Parametric

A crazy-parametric room transition — a parametric (epicycloid-style) wobble
distorts the outgoing room with increasing amplitude while the incoming room
settles into place. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_crazy_parametric::goto(rm_next);                          // default wobble
::transition_crazy_parametric::goto(rm_next, 1.5, { amplitude: 120.0 }); // tune the wobble
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The crazy-parametric effect is adapted from the MIT-licensed
  [`CrazyParametricFun.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CrazyParametricFun.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
