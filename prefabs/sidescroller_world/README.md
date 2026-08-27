# sidescroller_world

An empty side-scrolling world to start a game from. One object does the work:
`obj_world` draws a tileable 1600×900 backdrop at 2× across a 3200×1800
physics room, builds the floor and walls, and scrolls a safe-zone camera after
whatever asks to be followed. The shipped backdrop is a deliberately generic
grey city street stamped **REPLACE ME** — it exists to be replaced.

## Quick usage

```sh
gmx prefab add gh:opera-gaming/prefabs/sidescroller_world
```

Then either use the ready-made room — put `::sidescroller_world::rm_world`
first in `project.toml`'s `room_order` — or place one
`::sidescroller_world::obj_world` in a room of your own. Your room needs:

```toml
size = { width = 3200, height = 1800 }   # one backdrop at 2x; wider rooms tile it
enable_views = true
physics_world = true
physics_gravity_y = 120.0
physics_pix_to_meters = 0.1

[[views]]
visible = true
x_view = 0
y_view = 900
w_view = 1600
h_view = 900
w_port = 1600
h_port = 900
```

`obj_world` draws just in front of the room's background colour layer, so it
can sit on any instances layer.

## Replacing the backdrop

Use the **generating-backgrounds** skill (installed by `gmx init`):

```sh
.claude/skills/generating-backgrounds/scripts/make_background.sh \
  --project . --name spr_bg_city --style "a city street in the style of a 90s ninja cartoon"
```

then point the world at it — per instance, in the room:

```toml
[[entries]]
object = "::sidescroller_world::obj_world"
overrides = [{ name = "bg_sprite", value = "spr_bg_city" }]
```

Any 16:9 sprite works; skill-made ones put the ground line at 73% of the
height, which is what `ground_frac` (0.73) expects. Set it if yours differs.

## Variables (on `obj_world`)

| Variable | Default | Meaning |
|---|---|---|
| `bg_sprite` | `-1` (= `spr_bg`) | the backdrop sprite |
| `bg_scale` | `2.0` | how big the backdrop is drawn |
| `ground_frac` | `0.73` | where the ground line is in the backdrop, as a fraction of its height |
| `wall_t` | `16` | thickness of the floor/wall colliders, px |
| `walk_margin` | `200` | how far from the walls a walker may go (the walkable range hand-off) |

## The hand-off

The world knows nothing about characters. It publishes globals in Create and
reads two back every End Step; anything can use them (`character_2d` does):

| Global | Set by | Meaning |
|---|---|---|
| `global.sidescroller_ground_y` | world | room y of the ground line — where feet go |
| `global.sidescroller_left` / `_right` | world | the walkable x range |
| `global.sidescroller_focus_x` / `_y` | you | what the camera should keep in view; `world_focus(x, y)` sets both |

Physics note: Box2D only generates contacts between objects that have a
collision event for each other. `obj_wall` (the floor/walls) has none; add a
`Collision_::sidescroller_world::obj_wall` event to your own physics objects,
or lay your own colliders (character_2d does the latter, so it needs nothing
from here).

## API

- `world_focus(x, y)` — call every step from whatever the camera should follow.
- `world_cam_follow_x(cam_x, focus_x, view_w)` / `world_cam_follow_y(cam_y, focus_y, view_h)` — the safe-zone follow, for a custom camera.
