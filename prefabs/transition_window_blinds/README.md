# Transition Window Blinds

A window-blinds room transition — alternating horizontal bands sweep between the
outgoing and incoming rooms like closing blinds. Derived from
**transition-base**: it overrides only `shaders/sh_transition/fragment.fsh` and
inherits the `goto` API, the transition machinery, and the demo.

## Usage

```gml
::transition_window_blinds::goto(rm_next);       // default blinds
::transition_window_blinds::goto(rm_next, 1.5);  // slower blinds
```

## Attribution & license

- Transition machinery + base, and this prefab's packaging: © Opera Software —
  MIT (inherited from `transition-base`).
- The window-blinds effect is adapted from the MIT-licensed
  [`windowblinds.glsl`](https://github.com/gl-transitions/gl-transitions/blob/master/transitions/windowblinds.glsl)
  in [gl-transitions](https://github.com/gl-transitions/gl-transitions)
  (© its respective author; see the source file for the individual credit).
