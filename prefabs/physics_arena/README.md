# physics_arena

Roll a ball with real physics, knock out the targets, beat the clock.

## `physics_world = true` or nothing happens

The play room sets it. Without that flag the room looks entirely correct,
every body is declared correctly, and nothing simulates. It is the first
thing to check when a physics game does nothing.

The second thing: **built-in `speed`/`direction`/`hspeed`/`vspeed` do nothing
to instances in a physics room.** An object relying on them sits still while
looking perfectly configured. Move bodies with `phy_*` or
`physics_apply_*`, and non-physics objects by writing `x` and `y` yourself.

## Restitution is the feel, and the trap

`restitution = 1.05` on the bumpers is why the arena has energy. Above about
1.1 the ball *gains* speed on every bounce, and the speed cap stops being a
safety net and becomes the only thing keeping it in the room.

That is why `phys_clamp_speed` runs every frame even though `phy_bullet` is
also set. Continuous collision handles a fast body; it does not handle a body
that keeps getting faster.

## Fixtures are in final pixels

`[physics.body.shape]` gives the ball a 17px radius directly, and deliberately
does **not** use `scale = "instance"`. That option bakes the fixture at
instance-creation scale — which runs *before* `Create.gml` can set
`image_xscale` — so a sprite scaled in Create ends up with a hitbox from
before the scaling. The jam bug this comes from left a 74px fixture on a 16px
gem.

## Impact is a velocity delta, not a collision event

A target breaks on a hard enough hit, and "hard enough" is how much the
ball's velocity *changed* this frame. That gives one event per bounce with a
magnitude, rather than a collision event per frame of contact with none.

`break_impact` and `speed_cap` are both **pixels per step**, the same unit as
every other speed in a GameMaker game.

That is worth stating because GameMaker offers the velocity twice:
`phy_speed_*` per step and `phy_linear_velocity_*` per second, `room_speed`
apart. Measured on the runner, a linear velocity of 30 is a `phy_speed` of
0.499 and moves the body 14.7px in 30 frames. A physics library quoting
seconds inside a catalog that quotes steps is how a launch speed of 22 ends up
moving a ball a third of a pixel per frame — which is exactly what this prefab
did until the numbers were measured rather than assumed.

## What it does not do

No flippers, no launcher, no gravity — `physics_gravity_y` is 0, so this is a
top-down table. A pinball table is this plus gravity, two `revolute` joints
and a plunger.
