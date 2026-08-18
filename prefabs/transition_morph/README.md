# Transition Morph

A morph room transition — the outgoing and incoming rooms warp into one another
along their colour gradients as they cross-fade. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_morph::goto(rm_next);                            // default morph
::transition_morph::goto(rm_next, 1.5, { strength: 0.2 });  // stronger warp
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The morph effect is adapted from the MIT-licensed
  [`morph.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/morph.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
