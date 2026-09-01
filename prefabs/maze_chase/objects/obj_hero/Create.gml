move_speed = ::kernel::kernel_tuning("hero_speed", 3);
vitals = ::health::health_make(
    ::kernel::kernel_tuning("hero_lives", 3),
    ::kernel::kernel_tuning("iframe_seconds", 1.5));

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
dot_score = ::kernel::kernel_tuning("dot_score", 10);

// The maze walls are the room's `Tiles` layer, not instances — resolved once
// here because `layer_get_id` per axis per frame is a lookup for an answer
// that cannot change while the room is loaded.
walls = ::motion::motion_tilemap("Tiles");
