# Transition Circle Crop

A circle-crop room transition — the outgoing room collapses into a shrinking
circle over a background colour, then the incoming room grows back to fill the
screen. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_circle_crop::goto(rm_next);       // default crop
::transition_circle_crop::goto(rm_next, 1.5);  // slower crop
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The circle-crop effect is adapted from the MIT-licensed
  [`CircleCrop.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CircleCrop.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
