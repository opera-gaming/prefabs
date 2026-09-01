# sokoban

Push every crate onto a mark. You can push, never pull, so a mistake is permanent.

## Undo is a mechanic, not a convenience

Pushing is irreversible: a crate in a corner stays there. A Sokoban without
undo is one you restart from the beginning on every mistake, which is why
nobody finishes it.

Undo restores a **whole board snapshot** rather than trying to reverse the
last push. That stays correct for a move that both walked and pushed, where
reversing would have to undo two things in the right order.

The snapshot copies row by row. Assigning the arrays would share them, and the
undo would then mutate along with the board it is meant to restore — a bug
that looks like undo simply not working.

## Marks are stored separately from crates

A crate standing on a mark must not erase it, or the level becomes unwinnable
the moment you push the first crate into place and the mark disappears. Two
parallel grids, one for what is in a cell and one for what the cell is.

`soko_solved` counts marks rather than crates, so a level with a spare crate
still completes.

## Levels are text

`content.levels` is an array of string blocks — `#` wall, `$` crate, `.` mark,
`@` start, `*` a crate already on a mark. Adding a level is adding a block.
Nothing else changes.

## What it does not do

No move limit, no par score, no level select — levels run in order and the
game ends after the last. Score is negative per move and positive per level,
which is a placeholder for whatever scoring you actually want.
