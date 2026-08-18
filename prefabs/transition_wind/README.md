# Transition Wind

A wind room transition — the outgoing room is blown away in noisy horizontal
streaks to reveal the incoming room. Derived from **transition-base**: it
overrides only `shaders/sh_transition/fragment.fsh` and inherits the `goto` API,
the transition machinery, and the demo.

## Usage

```gml
::transition_wind::goto(rm_next);                        // default gust
::transition_wind::goto(rm_next, 1.5, { size: 0.4 });  // wider streaks
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The wind effect is adapted from the MIT-licensed
  [`wind.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/wind.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
