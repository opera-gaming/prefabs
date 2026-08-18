# Transition Random Squares

A random-squares room transition — the screen is divided into a grid of square
tiles that switch to the incoming room in a random, spreading order. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_random_squares::goto(rm_next);                              // default
::transition_random_squares::goto(rm_next, 1.5, { smoothness: 0.5 });  // tune edge softness
```

The grid resolution (`size`) is a baked default and not exposed as a tunable param.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The random-squares effect is adapted from the MIT-licensed
  [`randomsquares.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/randomsquares.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
