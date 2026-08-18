# Transition Bowtie

A bowtie room transition — twin triangular wedges open outward from the left and
right edges (a horizontal bowtie) to reveal the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_bowtie::goto(rm_next);   // horizontal bowtie
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The bowtie effect is adapted from the MIT-licensed
  [`BowTieHorizontal.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BowTieHorizontal.glsl)
  / [`BowTieVertical.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BowTieVertical.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
