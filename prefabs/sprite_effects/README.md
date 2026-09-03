# sprite_effects

Eleven subject shaders, ready to draw a sprite or rig through, with the
`sprite_fx` host built in (derived from it via `[parent-link]`, so this is
the only prefab to add). Each shader carries its host settings and uniform
defaults in `shader.toml`; open one in the editor to see it play and tune it.

```sh
gmx prefab add gh:opera-gaming/prefabs/sprite_effects
```

```gml
// Create
fx = ::sprite_effects::vfx_create(::sprite_effects::shd_fire);
::sprite_effects::vfx_set(fx, "uHeat", 0.8);

// Draw
::sprite_effects::draw_sprite_vfx(fx, sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Clean Up
::sprite_effects::vfx_destroy(fx);
```

| Shader | Effect | Uniforms |
|---|---|---|
| `shd_fire` | Flames licking up off every edge, with smoke above and a charred, ember-lit rim. | Reach, Turbulence, Speed, Wobble, Heat, Smoke, Ember rim |
| `shd_frost` | Cold water dripping down off every edge, with glints and a wet caustic sheen inside. | Reach, Flow, Waviness, Sheen |
| `shd_electric` | Crackling discharge along the silhouette: jagged arcs, hot filaments and a charged rim. | Reach, Density, Flicker, Jaggedness, Detail, Thickness |
| `shd_air` | Wisps of wind spiralling around the silhouette. | Streams, Speed, Reach, Intensity |
| `shd_earth` | Rings of rock chunks orbiting the silhouette through a haze of dust. | Reach, Orbit, Density, Chunk size |
| `shd_glow` | A breathing halo outside the silhouette and rings of light travelling inward from the edge. | Width, Rings, Pulse rate, Intensity, Colour |
| `shd_outline` | A flat band outside the silhouette that trails a moving subject. | Width, Gap, Softness, Colour, Brightness |
| `shd_sparkle` | Twinkling stars orbiting the silhouette in counter-rotating rings. | Reach, Density, Twinkle, Size, Orbit |
| `shd_explode` | Repeating detonations: a silhouette-shaped shockwave, flung debris and a white-hot flash. | Rate, Radius, Debris, Flash, Flash length |
| `shd_teleport` | Dissolve into motes along a glowing noise front, then reassemble. | Rate, Grain, Edge, Sweep, Motes, Colour |
| `shd_endgame` | Turn to stone, crumble along a noise front and blow away as dust. | Rate, Grain, Sweep, Blow, Dust, Colour |

`shd_explode`, `shd_teleport` and `shd_endgame` loop at their `Rate` and
snapshot the silhouette at the start of each cycle, so the effect keeps the
shape it detonated from while the sprite animates on; `vfx_get(fx, "uTlpRate")`
gives the rate, so `0.5 / rate` seconds is the point where a teleport is fully
dispersed and `1 / rate` where it has reassembled. The others trail a moving
subject with `linger`.

The uniform names and ranges are in each shader's `shader.toml`; pass them to
`vfx_set` by name (`"uFlameLen"`, not the label).
