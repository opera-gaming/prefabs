# Transition Doom

A Doom-style room transition — the outgoing room dissolves as a set of vertical
bars slide down at staggered speeds, recreating the classic DOOM screen melt.
Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_doom::goto(rm_next);                              // classic melt
::transition_doom::goto(rm_next, 1.5, { amplitude: 3.0 });   // more speed variation
```

Tunable uniforms: `amplitude` (per-bar speed variation, default 2.0),
`frequency` (horizontal wave frequency, default 0.5). Bar count, noise, and
drip are baked (30 bars, 0.1 noise, 0.5 drip).

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The doom effect is adapted from the MIT-licensed
  [`DoomScreenTransition.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DoomScreenTransition.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
