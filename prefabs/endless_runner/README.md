# endless_runner

Jump the gaps on ground that never stops, and get further than last time.

## The world moves, not the player

The player stays around x=220 and the ground scrolls past. That is what makes
it endless: the room never grows, and there is no camera to follow anything.

The corollary is that ground tiles must be **destroyed** once they leave the
left edge. Without it a two-minute run accumulates thousands of instances and
the frame rate falls away long after the mistake that caused it.

## The opening stretch is always solid

`safe_left` guarantees a screen and a bit of unbroken floor before any gap can
be generated. This is not politeness — a gap generated under the start drops
the player before they have pressed anything, and that reads as the game being
broken rather than as a hard game. It is worth checking every generator you
write for the equivalent.

## Gaps are capped against the jump

`gap_max_cells` exists so a generated gap is always clearable at the current
speed. A gap wider than the jump is unfair rather than hard, and the player
cannot tell the difference from the inside — they only know they died. Raise
`jump_strength` before raising the gap.

## One column at a time

The world is emitted a column at a time rather than in chunks. A gap that
straddles a chunk boundary is exactly the case that produces something
unjumpable, and generating per column means that case does not exist.

## What it does not do

No obstacles other than gaps, no pickups, no ceiling. Difficulty is
`scroll_gain` alone, which is enough to be going on with and not enough for a
finished game.
