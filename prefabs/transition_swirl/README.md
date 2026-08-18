# Transition Swirl

A swirl room transition — the frame twists into a spiral and unwinds to reveal
the incoming room. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_swirl::goto(rm_next);        // 1s swirl
::transition_swirl::goto(rm_next, 1.5);   // slower swirl
```

This effect takes no extra parameters.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The swirl effect is adapted from the MIT-licensed
  [`Swirl.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Swirl.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
