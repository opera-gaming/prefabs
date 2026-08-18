# Transition Polka Dots Curtain

A polka-dots-curtain room transition — a grid of dots expands outward from a
corner, growing until they cover the screen and reveal the incoming room.
Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_polka_dots_curtain::goto(rm_next);                     // default grid
::transition_polka_dots_curtain::goto(rm_next, 1.5, { dots: 30.0 }); // denser dots
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The polka-dots-curtain effect is adapted from the MIT-licensed
  [`PolkaDotsCurtain.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PolkaDotsCurtain.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
