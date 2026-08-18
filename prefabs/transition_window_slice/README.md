# Transition Window Slice

A window-slice room transition — a set of vertical slices wipe across the screen
to reveal the incoming room. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_window_slice::goto(rm_next);                                        // default slices
::transition_window_slice::goto(rm_next, 1.5, { count: 20.0, smoothness: 0.2 }); // more, crisper slices
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The window-slice effect is adapted from the MIT-licensed
  [`windowslice.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/windowslice.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
