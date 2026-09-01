# top_down_arena

Survive waves in one room: move, dodge, collect, and last as long as you can.

## One room, and a curve instead of levels

There is no level two. Difficulty is entirely the spawn curve, which means the
whole game is tuned by three numbers in the data script:

- `spawn_interval` — seconds between spawns on wave one
- `spawn_scale` — what that is multiplied by each wave, below 1 to get harder
- `spawn_floor` — the fastest it will ever go

Those three decide whether minute five is playable, and they are the first
thing to change. `wave_budget` also raises how many arrive at once, which is
what keeps the curve climbing after the interval bottoms out — a curve that
only tightens the interval flattens completely once it hits the floor.

## The invulnerability window is load-bearing

`iframe_seconds` is not polish. An enemy that stays overlapping deals damage on
every frame it touches you, so without a window a single contact drains the
whole bar in a few frames and the run ends before the player understands they
were touched. The game validates, builds and boots perfectly while being
unplayable.

The player flashes while the window is open, which is the other half — a player
who cannot see why they are not taking damage assumes the collision is broken.

## Enemies push each other apart

`ai_separate` runs once per frame from `obj_arena`, not from each enemy. It
moves the *other* instances, so calling it in every enemy's Step doubles every
push and the group jitters.

Without it, chasers converge onto the same point and stack into what reads as a
single enemy — which then lands several hits at once, through the i-frame
window, because each is a separate collision.

## Spawning happens at the edges

A wave that appears on top of the player is not difficulty, it is a coin flip.
`obj_arena` picks a room edge and spawns there, so every enemy has to cross the
floor to reach you and you always have somewhere to run.

## What it does not do

No shooting, no power-ups, no second room. `projectile` and `powerup` are the
two prefabs that fit it best if you want them — `gmx prefab add projectile
--project .` and give the player a fire button.
