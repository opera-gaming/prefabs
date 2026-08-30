# character_2d

A side-view paper-doll character to build on. The rig is a grey mannequin that
exists to be re-skinned; the behaviour is the point: hold a finger beside it
and it walks there (runs when far), hold above its head and it jumps that
way, press on it and it kicks, knock it down and it lies as a Box2D
ragdoll until still, then gets up by itself. A kinematic capsule moves with it
so it pushes and blocks like a body in a physics world. No world, no enemies,
no UI — drop it into `sidescroller_world`.

## Quick usage

```sh
gmx prefab add gh:opera-gaming/prefabs/character_2d
```

Place one `::character_2d::obj_character` in a **physics room** (`physics_world
= true`), with its `y` on the ground line — in a `sidescroller_world` room that
is `global.sidescroller_ground_y` (1314 for the default backdrop), and the
character reads the world's hand-off itself: ground, walkable range, camera.
Standalone, it needs an `::character_2d::obj_solid` floor or lays one on its
own ground line.

## Re-skinning

Make a rig with the **generating-rig-characters** skill, then either set it per
instance in the room —

```toml
[[entries]]
object = "::character_2d::obj_character"
overrides = [{ name = "rig_asset", value = "rig_ninja" }]
```

— or at runtime: `::character_2d::character_set_rig(inst, rig_ninja)`.
Every rig made by the skill attaches to the same clips.

## Variables (on `obj_character`)

| Variable | Default | Meaning |
|---|---|---|
| `rig_asset` | `-1` (= `rig_mannequin`) | the RIG asset to wear |
| `char_scale` | `-1` | size; 1.0 is 300 px per metre (a 1.8 m rig is 540 px tall). `-1` takes it from the world's `global.sidescroller_px_per_m` (0.8 without a world) |
| `jump_height_m` | `2.7` | how high a jump goes, metres |
| `jump_forward_m` | `2.0` | forward speed of a jump, metres per second (a walk's own speed if faster) |
| `jump_gravity_g` | `2.0` | gravity for jumps and falls, in Earth gravities |
| `tap_control` | `true` | a held finger/button is walked or run towards (idles once caught up), held above the head is jumped towards, a press on the body kicks; below the feet is left to the game. Off for a game-driven character |
| `camera_focus` | `true` | the world's camera follows this one; off for enemies and extras |
| `run_distance_m` | `3.0` | a held finger farther than this (metres) runs, nearer walks |
| `facing` | `1` | initial facing, 1 right / -1 left |

## API

| Function | Does |
|---|---|
| `character_walk_to(inst, x, [run])` | walk (or run) to room x, then idle (clamped to the walkable range) |
| `character_kick(inst)` | a kick where it stands, then idle |
| `character_kick_hit(inst, [r])` | the other character the ongoing kick lands on this step (at the kick clip's `hit` markers), or noone |
| `character_flash(inst, [secs], [blink])` | draw it white for a moment: solid, or blinking every `blink` seconds |
| `character_jump(inst)` | jump (the clip carries the lift), then idle |
| `character_hit_test(inst, x, y, r)` | the bone whose body a point within `r` px touches in the current pose, or undefined — a projectile's hit test, no physics needed. Give the projectile physics `group = -1` (the capsule's) so the capsule does not bat it away |
| `character_ragdoll(inst, ix, iy, [bone])` | drop as a ragdoll with a shove of `ix, iy` px/step — on the whole doll, or on `bone`'s body alone; it gets up by itself. Returns false if already down |
| `character_is_down(inst)` | true while a ragdoll |
| `character_set_rig(inst, rig)` | re-skin where it stands |
| `character_point_on(inst, px, py)` | whether a room point lands on the standing body |
| `character_ragdoll_tuning()` | the struct of live physics feel (damping, rest time, blend) — edit its fields |

A hit from your own physics object: give it a
`Collision_::character_2d::obj_character` event and call
`var b = ::character_2d::character_hit_test(c, x, y, 12); if (!is_undefined(b)) ::character_2d::character_ragdoll(c, phy_speed_x * 0.8, phy_speed_y * 0.8, b);`.
While down, the limbs are `::character_2d::obj_ragdoll_part` instances — grab
and fling them by setting their `phy_speed_x/y`.

## Clips

`clip_idle` (Mixamo Happy Idle), `clip_walk`, `clip_jump`, `clip_getup_front`,
`clip_getup_back`. Add more with the **importing-rig-clips** skill from any
Mixamo FBX; the get-up clips carry `rise` / `upright` markers the ragdoll
hand-off needs.

## How it fits together

The clips carry root motion, so the rig walks itself; the capsule is
kinematic and is placed on the rig every step (never pushed). When the
character ragdolls the capsule is switched off and the runtime builds limb
bodies from the rig's layout; once they lie still for `rest_time` the doll is
blended into whichever get-up clip matches how it landed, and the idle is
queued to crossfade in at the `upright` marker. Collisions with the floor work
because `obj_ragdoll_part` has a collision event with `obj_solid`, and the
character lays `obj_solid` colliders on the world's ground line at start.
