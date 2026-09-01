# Rhythm

Four lanes, arrow keys, notes falling to a 120 BPM track. Hit a note as it
crosses the line to score; let it past and the combo breaks.

The point of this one is its clock. `obj_rhythm` reads
`audio_sound_get_track_position` once per step and every other number in the
game is derived from it — where each note is drawn, whether a press counts,
and when the song is over. There is no frame counter anywhere, which is what
keeps the notes on the beat rather than near it.

## Playing it

    gmx run .

Arrow keys, one per lane. The count-in is four beats; the first note lands two
seconds in.

## Checking it

    gmx test rhythm.gametest.json --project .

It needs a runtime whose headless audio works, and until one ships that means
passing `--dev-runtime`. On an older runtime all eight asserts fail with `0.0`
and the HUD sits at `0.00 / 8.00s`: that is the bug below being reported, not
a broken recipe.

Eight asserts, covering the whole audio path this game depends on: that
`audio_play_sound` hands back a playable voice, that its position advances at
one second per sixty frames, that the chart spawns notes off that position,
that a press on the beat is judged a hit, and that the position clamps at the
end of the track instead of running past it.

Those asserts are worth more than they look. All of them are true of a working
runner and all of them were silently false of a headless one until recently:
a run with no audio device reported position 0 forever, so a rhythm game built
on it looked like it was working and simply never spawned a note.
