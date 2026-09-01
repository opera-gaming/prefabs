var _t = platformer_tuning();
walk = ::motion::motion_platformer_make({
    run_speed: _t.enemy_speed,
    jump_strength: _t.jump_strength,
    gravity_per_frame: _t.gravity_per_frame,
    tilemap: ::motion::motion_tilemap("Tiles")
});

// -1 or 1, not a GameMaker `direction` in degrees. `direction` is a built-in
// that drives the engine's own motion, and borrowing it for a sign is how a
// patrol ends up moving in a way nothing in this file explains.
facing = 1;

// Settle onto the ground under wherever it was put.
//
// A patrol placed in open air — a coordinate someone guessed, a block deleted
// from under it — otherwise falls straight out of the level and is gone, with
// nothing on screen and nothing in a log to say so. Landing it on the first
// solid below turns that mistake into a working enemy in the obvious place.
// An enemy already standing on a block does not move at all.
while (y < room_height && !::motion::motion_blocked(noone, walk.tilemap, x, y + 1)) {
    y += 1;
}

// Where it goes back to if it ever ends up below the level anyway — over a
// pit, say, where the loop above found nothing to stand on.
start_x = x;
start_y = y;
