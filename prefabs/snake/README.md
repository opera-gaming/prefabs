# snake

Eat, grow, and do not bite yourself — one step at a time on a grid.

## It moves on a tick, not on a frame

The snake advances every `step_seconds`, not every frame. That is what makes
the game readable — a body that moved continuously would need sub-cell
positions and the collision would stop being exact.

Turning is **buffered**: a key press records `next_dir`, and the tick applies
it. Without the buffer a player who taps twice between two ticks loses the
first input; with it, and without the reversal guard below, they turn back
into their own neck.

```gml
if (keyboard_check_pressed(vk_left) && dir.col == 0) next_dir = { col: -1, row: 0 };
```

The `dir.col == 0` test is the reversal guard: you may only turn onto an axis
you are not already travelling along.

## Growing is not adding, it is failing to remove

Every tick pushes a new head. Eating simply *skips* deleting the tail:

```gml
array_insert(body, 0, _next);
if (ate) { ... } else { array_delete(body, array_length(body) - 1, 1); }
```

One branch, and the body length takes care of itself.

## The difficulty curve is three numbers

`step_seconds` falls by `step_gain` on every meal, never below `step_floor`.
That is the whole ramp — there is nothing else to tune.

## What it does not do

No walls inside the board, no wrap-around edges, no second snake. Wrapping is
a two-line change in the bounds check if you prefer it to dying.
