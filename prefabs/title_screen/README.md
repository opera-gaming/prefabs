# title_screen

A logo that breathes, a prompt, and a key or click to start.

## The decisions this makes for you

**It animates on `delta_time`, not on frames.** A frame counter runs the
wiggle at double speed on a 120Hz display. This is the single most common
way a title screen differs between machines.

**It advances on `confirm`, which is space, enter or a click.** Prefer
release over press if you add your own key handling: whatever key brought
the player here from a results screen is often still held on the frame
this room starts, and a press handler consumes it immediately.

## Adding a logo

```
gmx prefab add ninja_woods/sprites/spr_game_logo --centre-origin
```

`--centre-origin` because the bob applies to the sprite's origin — with a
top-left origin the logo swings rather than breathes.
