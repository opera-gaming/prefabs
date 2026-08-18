# Transition Burn

A film-burn room transition — a warm color flare washes across the frame as the
outgoing room burns into the incoming one. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_burn::goto(rm_next);   // default warm flare
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The film-burn effect is adapted from the MIT-licensed
  [`FilmBurn.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FilmBurn.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
