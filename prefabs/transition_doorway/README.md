# Transition Doorway

A doorway room transition — the outgoing room splits open down the middle like a
pair of doors while the incoming room zooms in behind it, with a soft floor
reflection. Derived from **transition-base**: it overrides only
`shaders/sh_transition/fragment.fsh` and inherits the `goto` API, the transition
machinery, and the demo.

## Usage

```gml
::transition_doorway::goto(rm_next);                          // default doorway
::transition_doorway::goto(rm_next, 1.5, {                    // tune the look
    reflection: 0.4, perspective: 0.4, depth: 3.0 });
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The doorway effect is adapted from the MIT-licensed
  [`doorway.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/doorway.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
