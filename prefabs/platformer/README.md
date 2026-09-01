# platformer

Run, jump, collect, reach the flag — a whole side-view game to start from.

## The level is the tile layer

The terrain lives in `rooms/rm_level/layers/Tiles.toml`, and that is the only
copy of it. There is no map file beside it to keep in step — a second copy of
the shape is a thing that can disagree with the tiles, and the way to not have
that problem is to not have the second copy.

Read the shape back out of the layer:

```console
$ gmx autotile shape rm_level
14 rows ↓ × 90 cols → — ops address row,col, zero-based
    0         10        20        30
    01234567890123456789012345678901
 6  .........####.............
 7  ......................###.
 9  ########........####......
```

Edit it with the same command, which redraws the tiles and the legend in the
same run:

```
gmx autotile shape rm_level --op 'rect 6,20 6,26 fill'
```

The tile index is never yours to pick: each filled cell gets the tile that fits
its neighbours, out of the `[autotile]` table in
`tilesets/ts_terrain/tileset.toml`. That is why a platform's ends are drawn
differently from its middle without you saying so, and why widening one redraws
its cap and adds the masks it now needs. A shape the sheet cannot draw is
refused with the offending cells named, rather than written and left to look
wrong — `--repair` adjusts the shape until it can be drawn, and prints the diff
before changing anything.

The actors — player, coins, enemies, goal — are placed instances in the same
room. Drag them in the editor, or edit
`rooms/rm_level/layers/Instances.toml`.

## Collision is against the tile layer

`::motion::` resolves one axis at a time against `Tiles`. Both halves matter:
moving both axes at once before backing out of a wall is what produces a
character who sticks to ceilings, and tile index 0 is always empty, so the
sheet's first row is left blank and the 47-tile template starts on its second.

## The jump is three numbers and two forgivenesses

`jump_strength`, `gravity_per_frame` and `fall_max` set the arc. The two that
decide whether it *feels* right are in `::motion::` rather than here:

- **Coyote time** — jumping still works for a few frames after walking off a
  ledge. Without it, a player who presses on the exact frame they leave the
  ground gets nothing and blames the controls.
- **Input buffering** — a press slightly before landing is remembered and fires
  on touchdown.

Variable height comes from halving upward velocity when the key is released, so
a tap is always a small hop at any frame rate.

## What it does not do

No moving platforms, no checkpoints, one level. Falling out of the world
restarts the room. Those are the next things to add, and they are deliberately
absent — this is a floor to build on, not a game to ship.
