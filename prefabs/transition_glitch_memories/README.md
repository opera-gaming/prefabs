# Transition Glitch Memories

A glitch room transition — a blocky, chromatic RGB channel-split jitter that
shakes and then settles onto the incoming room. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_glitch_memories::goto(rm_next);   // no tunable params
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The glitch-memories effect is adapted from the MIT-licensed
  [`GlitchMemories.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchMemories.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
