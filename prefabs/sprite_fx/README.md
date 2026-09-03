# sprite_fx

The in-game host for shaders written for the editor's subject preview
(`[host] kind = "subject"` in `shader.toml`). An effect instance captures what
is drawn between `vfx_begin` and `vfx_end` into a square padded by the shader's
margin, builds the distance field the shader samples, and composites the
shader over the capture where the subject was. Margin, linger, drift, snapshot
and the uniform defaults all come from the shader, so it looks in game as it
does in the editor.

```sh
gmx prefab add gh:opera-gaming/prefabs/sprite_fx
```

```gml
// Create
fx = ::sprite_fx::vfx_create(shd_fire);

// Draw
::sprite_fx::draw_sprite_vfx(fx, sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
// or, for anything else, the box and the drawing yourself; the key skips
// the drawing and the silhouette while the subject stays the same:
if (::sprite_fx::vfx_begin(fx, bbox_left, bbox_top, bbox_right - bbox_left, bbox_bottom - bbox_top, [sprite_index, floor(image_index)])) draw_self();
::sprite_fx::vfx_end(fx);

// Clean Up
::sprite_fx::vfx_destroy(fx);
```

| Function | Meaning |
|---|---|
| `vfx_create(shader)` | New instance for a subject shader; settings and defaults from the shader. |
| `vfx_destroy(fx)`, `vfx_exists(fx)` | Lifetime; frees the surfaces. |
| `vfx_set(fx, name, value)`, `vfx_get(fx, name)` | A `[[uniform]]` by name: number, bool, an array for vec2..4 and colour, or a sprite for a sampler. |
| `vfx_set_time(fx, seconds)`, `vfx_get_time(fx)` | The effect clock, otherwise advanced by `delta_time` on each draw. |
| `vfx_retake(fx)` | Forget the field (subject swapped, teleported, respawned). |
| `vfx_set_scale(fx, s)` | Capture resolution relative to screen pixels; default 1. |
| `vfx_begin(fx, x, y, width, height, [key])` … `vfx_end(fx)` | Everything drawn between goes into the capture of that room box; `vfx_end` builds the field and composites. `key` (a value or an array) names what the capture will hold: when it equals the held capture's, `vfx_begin` keeps the capture and its silhouette and returns false, and the caller skips its drawing. |
| `draw_sprite_vfx(fx, sprite, subimg, x, y, xscale, yscale, rot, colour, alpha)` | `draw_sprite_ext` through the effect. The box is the scaled sprite; a rotated one gets the circle its corners sweep, so the field stays put through a spin. `colour` and `alpha` tint the composite. |
| `draw_rig_vfx(fx, rig)` | `draw_rig` through the effect. The box is anchored to the rig's position and grows, in 16 px steps, to hold every pose since the effect was created or retaken, so it neither jitters with the limbs nor shrinks. |

One instance per drawn subject: the field is the subject's memory. The
capture is the box squared on its larger side, padded by `margin` on every
side, at the view's zoom rounded up to 32 pixels (2048 at most); the field is
`surface_rgba16float` where the runtime renders to it, else
`surface_rgb10a2unorm`, else 8-bit — the unorm formats clamp distances to
one texture unit.

A draw costs the capture, the silhouette (a jump flood of `log2` of the
capture's side passes), the field's resolve and the composite; on the gx.games
runner about 0.7 ms per effect at 256 px. While the subject stays the same —
`draw_sprite_vfx` keys on the sprite, frame, scale and angle — only the
resolve runs, and with `linger = 0` only the composite; a sprite that spins
or animates every frame pays the whole cost each frame.

The four `shd_vfx_*` shaders are the field passes; the editor preview runs
the same sources.
