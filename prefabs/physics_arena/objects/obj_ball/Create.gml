// Continuous collision first; the cap is the backstop behind it.
phy_bullet = true;
body = ::physics_body::phys_make(::kernel::kernel_tuning("speed_cap", 30));
squash = 0;

// The ball launches itself, so a second one dragged into the room in an
// editor works with no code change at all.
::physics_body::phys_launch(irandom(359),
    ::kernel::kernel_tuning("launch_speed", 22));

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
break_impact = ::kernel::kernel_tuning("break_impact", 9);
target_score = ::kernel::kernel_tuning("target_score", 100);
nudge_force = ::kernel::kernel_tuning("nudge_force", 0.4);
launch_speed = ::kernel::kernel_tuning("launch_speed", 22);
