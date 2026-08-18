# Transition Simple Zoom

A simple-zoom room transition — the outgoing room zooms into itself while the
incoming room fades in over the top. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_simple_zoom::goto(rm_next);                              // default zoom
::transition_simple_zoom::goto(rm_next, 1.5, { zoom_quickness: 0.5 }); // tune the zoom timing
```

Tunable params: `zoom_quickness` (default 0.8, clamped to 0.2..1.0).

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The simple-zoom effect is adapted from the MIT-licensed
  [`SimpleZoom.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SimpleZoom.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
