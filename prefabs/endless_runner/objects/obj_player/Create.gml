vy = 0;
grounded = false;

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
gravity_per_frame = ::kernel::kernel_tuning("gravity_per_frame", 0.75);
jump_strength = ::kernel::kernel_tuning("jump_strength", 15);
