fight = ::boss::boss_make(
    ::kernel::kernel_tuning("boss_hp", 400),
    ::kernel::kernel_tuning("boss_phases", 3));
moves = [
    { move: "ring",   phase: 1 },
    { move: "spiral", phase: 2 },
    { move: "aimed",  phase: 3 },
];
drift = 0;

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
telegraph_seconds = ::kernel::kernel_tuning("telegraph_seconds", 0.8);
recover_seconds = ::kernel::kernel_tuning("recover_seconds", 1.0);
