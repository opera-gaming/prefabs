# Transition Leaf

A leaf-shaped room transition — a serrated leaf silhouette grows from the centre
of the screen to reveal the incoming room. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_leaf::goto(rm_next);   // no tunable params
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The leaf effect is adapted from the MIT-licensed
  [`cannabisleaf.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/cannabisleaf.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
