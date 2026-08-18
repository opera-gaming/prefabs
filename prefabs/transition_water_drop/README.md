# Transition Water Drop

A water-drop room transition — concentric ripples spread from the centre and
distort the outgoing room as the incoming one fades in. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_water_drop::goto(rm_next);                                        // default ripple
::transition_water_drop::goto(rm_next, 1.5, { amplitude: 50.0, speed: 40.0 }); // stronger, faster
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The water-drop effect is adapted from the MIT-licensed
  [`WaterDrop.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WaterDrop.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
