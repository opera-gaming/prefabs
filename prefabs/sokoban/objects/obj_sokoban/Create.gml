// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);

cell = ::kernel::kernel_tuning("cell", 40);
levels = ::kernel::kernel_data("levels");
level_at = 0;
board = soko_load(levels[level_at]);
history = [];

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
move_score = ::kernel::kernel_tuning("move_score", -1);
level_score = ::kernel::kernel_tuning("level_score", 500);
