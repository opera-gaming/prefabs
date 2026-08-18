# Transition Perlin

A noise-dissolve room transition — the outgoing room breaks up along a Perlin
noise field to reveal the incoming room. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_perlin::goto(rm_next);                          // default dissolve
::transition_perlin::goto(rm_next, 1.5, { scale: 8.0, smoothness: 0.05 }); // finer, softer
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The perlin effect is adapted from the MIT-licensed
  [`perlin.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/perlin.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
