# Transition Fade Grayscale

A fade-through-grayscale room transition — desaturates the outgoing room to
grayscale mid-way, then resaturates into the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_fade_grayscale::goto(rm_next);                           // default
::transition_fade_grayscale::goto(rm_next, 1.5, { intensity: 0.3 }); // tune it
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The fade-grayscale effect is adapted from the MIT-licensed
  [`fadegrayscale.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/fadegrayscale.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
