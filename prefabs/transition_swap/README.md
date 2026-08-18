# Transition Swap

A swap room transition — the outgoing room slides back into depth while the
incoming room slides forward to take its place, with a floor reflection.
Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_swap::goto(rm_next);                                                   // default swap
::transition_swap::goto(rm_next, 1.5, { depth: 4.0, perspective: 0.3, reflection: 0.5 }); // tune it
```

Tunable params: `reflection` (default 0.4), `perspective` (default 0.2),
`depth` (default 3.0).

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The swap effect is adapted from the MIT-licensed
  [`swap.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/swap.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
