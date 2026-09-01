move_speed = ::kernel::kernel_tuning("ghost_speed", 2);
route = [];
repath = 0;

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
repath_seconds = ::kernel::kernel_tuning("repath_seconds", 0.35);
