# Transition Dreamy Zoom

A dreamy-zoom room transition — a rotate-and-zoom crossfade that spins and scales
the rooms and blooms to white at the midpoint. Derived from **transition-base**:
it overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto`
API, the transition machinery, and the demo.

## Usage

```gml
::transition_dreamy_zoom::goto(rm_next);                             // default
::transition_dreamy_zoom::goto(rm_next, 1.5, {                       // tune it
    rotation: 6.0, scale: 1.2 });
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The dreamy-zoom effect is adapted from the MIT-licensed
  [`DreamyZoom.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DreamyZoom.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
