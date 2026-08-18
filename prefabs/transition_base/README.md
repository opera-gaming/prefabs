# Transition Base

Room-to-room transitions for gmx / GameMaker. Captures the outgoing room to a
surface, switches rooms, captures the incoming room to a second surface, then
blends the two with a full-screen fragment shader over a set duration.

This is the **base**: it ships the machinery (`obj_transition`), the API
(`goto`), and a plain **fade** as the default effect (`sh_transition`). Derived
transitions inherit all of that via `[parent-link]` and override only
`shaders/sh_transition/fragment.fsh`.

## Usage

Once added to a project it is namespaced under the prefab folder, e.g.:

```gml
::transition_fade::goto(rm_next);             // 1s, default fade
::transition_fade::goto(rm_next, 1.5);        // 1.5s
```

`goto(room, [time], [params])` — `params` overrides the effect's tunable knobs
by uniform name (each a float), e.g. a derived effect might take
`{ amplitude: 60, speed: 2.0 }`. Unspecified knobs fall back to the effect's
`transition_defaults()` script, which lists exactly what a given effect exposes
and its default values. The base fade effect has no knobs.

## Attribution & license

© Opera Software — MIT (see `LICENSE`).
