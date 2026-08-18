# Transition Fade Color

A fade-through-color room transition — fades the outgoing room down to a solid
colour (black by default), then up into the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_fade_color::goto(rm_next);                          // fade via black
::transition_fade_color::goto(rm_next, 1.5, { color_phase: 0.4 }); // widen hold
```

The fade colour is baked to black; edit the `color` constant in the fragment
shader to fade through a different colour.

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The fade-color effect is adapted from the MIT-licensed
  [`fadecolor.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/fadecolor.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
