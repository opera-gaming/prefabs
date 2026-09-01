# spawner

Spawn things on a timer, in waves, without flooding the room.

## The alarm has to re-arm itself

An alarm is a frame counter, not a repeating timer: it fires once and stops.
Re-arming it inside its own event *is* the mechanism, and forgetting to is why
a spawner appears to work and produces exactly one enemy. `Alarm_0.gml` ends
with `alarm[0] = interval;` for that reason and no other.

The event filename grammar is closed — `Alarm_0` … `Alarm_11`. There is no
`Alarm_12` and no custom name.

## The population cap is not optional

`population_cap` is checked when a spawn is due, and a full room skips that
spawn rather than pausing the timer — so the wave keeps its rhythm and resumes
the moment there is space. Removing the cap does not make the game harder, it
makes minute ten a slideshow, and the frame rate falls off a cliff rather than
degrading.

## Difficulty is one multiplier

Each wave multiplies the interval by `interval_scale` and stops at
`interval_min`. Two numbers rather than a table of per-wave timings, because a
curve you can reason about is one you will actually tune. `wave_frames` sets how
long a wave lasts, in frames.

## The trap worth knowing

Give the spawned object a sprite. A spriteless object has no collision mask, so
nothing will ever hit it — the game runs, spawns correctly, and nothing can be
shot or touched, with no error anywhere to explain it.
