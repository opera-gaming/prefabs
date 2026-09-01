# bullet_hell

Thread the pattern. One hit ends it, so the hitbox is smaller than you are.

## The hitbox is much smaller than the ship

`hitbox_radius` is 4 against a 20px sprite, and collision is a distance check
rather than a sprite overlap. Every game in the genre does this, and it is not
a cheat: a hitbox matching the art makes a dense pattern *impossible* rather
than difficult, because there is no gap wide enough to pass through.

The prefab draws the hitbox as a dot. That is also standard — the player has
to be able to see the thing the game is actually testing.

Holding shift halves the speed for precise threading, which is the other half
of the bargain.

## Every pattern is telegraphed

Patterns are emitted on the boss's `telegraph_end`, never when the attack is
chosen. The wind-up is drawn as a ring that closes, so the player can time the
dodge instead of guessing it. A wall of bullets that arrives without warning
is not difficulty; the fight just reads as random.

## Bullets expire

`::projectile::projectile_step` ages each bullet and destroys it off-screen.
Without a lifetime, a two-minute fight leaves thousands of live instances and
the slowdown appears long after its cause.

## The spiral offsets per shot, not per ring

A ring of evenly spaced bullets is a wall. The spiral pattern adds a small
per-shot offset so the gaps rotate — the difference between a pattern you
thread and a pattern you die to.

## What it does not do

The player does not shoot. Scoring is survival time, and the boss is defeated
only by `boss_hurt` calls you add — wiring a fire button to it is the first
thing to do.
