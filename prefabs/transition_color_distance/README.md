# Transition Color Distance

A colour-distance room transition — pixels switch from the outgoing to the
incoming room based on the colour difference between the two, then the whole
frame fades to the incoming room. Derived from **transition-base**: it overrides
only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the
transition machinery, and the demo.

## Usage

```gml
::transition_color_distance::goto(rm_next);                       // default
::transition_color_distance::goto(rm_next, 1.5, { power: 5.0 }); // tune the fade power
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The colour-distance effect is adapted from the MIT-licensed
  [`ColourDistance.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColourDistance.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
