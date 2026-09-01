speed = ::kernel::kernel_tuning("ball_speed", 6);
direction = choose(230, 310);

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
ball_speed_gain = ::kernel::kernel_tuning("ball_speed_gain", 0.12);
brick_score = ::kernel::kernel_tuning("brick_score", 50);
steer = ::kernel::kernel_tuning("steer", 65);
