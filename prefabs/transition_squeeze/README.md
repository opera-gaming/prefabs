# Transition Squeeze

A squeeze room transition — the outgoing room squeezes vertically toward a line
with a chromatic-aberration smear while the incoming room is revealed. Derived
from **transition-base**: it overrides only `shaders/sh_transition/fragment.fsh`
and inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_squeeze::goto(rm_next);                                    // default squeeze
::transition_squeeze::goto(rm_next, 1.5, { color_separation: 0.08 }); // tune the smear
```

Tunable params: `color_separation` (default 0.04).

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The squeeze effect is adapted from the MIT-licensed
  [`squeeze.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/squeeze.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
