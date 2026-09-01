# breakout

Clear the bricks, do not drop the ball — and steer it with the paddle.

## The paddle is not a wall

`steer` is the number that decides whether the game has any skill in it. The
ball's bounce off the paddle is set by *where on the paddle it lands*, not by
the angle it arrived at:

```gml
var _offset = (x - _pad.x) / (_pad.sprite_width / 2);
direction = 90 + clamp(_offset, -1, 1) * steer;
```

At `steer = 0` the paddle reflects like a wall, every rally repeats, and the
player has no way to aim at the last brick in the corner. That one number is
the difference between a toy and a game.

## The bricks are placed entries

The wall lives in `rooms/rm_play/layers/Instances.toml` as real entries, so a
brick can be dragged in a visual editor, and that layer is the only copy of the
wall. Edit it there — there is no map file beside it to keep in step.

A brick is an instance rather than a tile because the game destroys it and
counts what is left: `instance_number(obj_brick) == 0` is how a cleared board
is detected, and a tile layer cannot answer that. Terrain that only has to be
collided against belongs in a tile layer; a thing the game counts, scores or
removes is an object.

The room stays inspectable either way — a level built by a spawn loop at run
time is neither readable nor editable.

## Walls are bounds, not objects

The room edge is not an instance, so the ball tests its own position against
`room_width`/`room_height` rather than colliding. The direction check matters:

```gml
if (x < 8 && lengthdir_x(1, direction) < 0) direction = 180 - direction;
```

Without the second half, a ball that is *already* inside the margin flips
every frame and vibrates along the edge instead of leaving it.

## What it does not do

No power-ups, no multi-ball, no second level — clearing the bricks ends the
run. `powerup` is the prefab that fits it best if you want falling capsules.
