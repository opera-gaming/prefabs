# maze_chase

Eat every dot before the ghosts corner you — they route round the walls.

## Ghosts route, they do not home

A chaser that moves straight at the player presses into the wall between you
and it, forever. `::pathgrid::` runs A* over the maze so a wall genuinely
hides you and the ghost comes round.

Recomputing every frame is wasted work on a maze this size; recomputing too
rarely means walking towards a wall you already left. `repath_seconds`
controls that, and 0.35 is a reasonable middle.

An empty route is a normal state, not an error — it means the target cell is
itself a wall. The ghost simply does not move that tick.

## Speed is a design constraint, not a difficulty knob

Raising `ghost_speed` past `hero_speed` makes the game *unwinnable* rather
than hard: a router that is strictly faster than you closes every distance
eventually, with no counterplay. Difficulty belongs in the number of ghosts
and the maze shape.

## The maze is a tile layer; the actors are instances

The walls live in `rooms/rm_play/layers/Tiles.toml`, and that layer is the only
copy of the maze. Read the shape back out of it, and edit it there:

```console
$ gmx autotile shape rm_play
15 rows ↓ × 28 cols → — ops address row,col, zero-based
    0         10        20
    0123456789012345678901234567
 0  ############################
 1  #............##............#
 2  #.####.#####.##.#####.####.#
```

```
gmx autotile shape rm_play --op 'rect 7,12 7,15 clear'
```

opens a passage and redraws the tiles in the same run. The tile index is never
yours to pick: each filled cell gets the tile that fits its neighbours from
`ts_maze`'s `[autotile]` table, so a corridor's corners and dead ends are drawn
correctly without the shape saying anything about them.

The dots, hero and ghosts are real entries in
`rooms/rm_play/layers/Instances.toml`, so any of them can be dragged in a
visual editor.

**Which of the two a thing belongs in** is decided by whether the game ever
counts or destroys it. A dot is an instance because `instance_number(obj_dot)`
is how a cleared board is detected. A wall is a tile because nothing counts,
destroys or moves one — it only ever answers "is this solid", and 222 instances
answering that were 222 entries carrying no other information.

Both halves are read rather than created: `obj_maze` counts the dots and blocks
the pathfinding grid from the tile layer in **Room Start**, not Create. Create
runs as each instance is made, so a controller placed first in the layer would
survey a half-built room.

## The i-frame window

Contact with a ghost costs a life, but only once per `iframe_seconds`. Without
it a ghost that stays overlapping takes all three lives in three frames, and
the game validates, builds and boots perfectly while being unplayable.

## What it does not do

No power pellets, no ghost states, no tunnels. Ghost behaviour is one mode —
always route to the player — and giving each a personality is the first thing
to add.
