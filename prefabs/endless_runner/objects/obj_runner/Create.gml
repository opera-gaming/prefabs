// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);

cell = ::kernel::kernel_tuning("cell", 64);
scroll = ::kernel::kernel_tuning("scroll_speed", 6);
travelled = 0;
next_x = 0;
gap_left = 0;
// Columns of guaranteed floor before any gap may appear.
safe_left = ceil(room_width / cell) + 2;

// A run of solid ground to start on, so the first jump is a choice rather
// than a reflex.
repeat (ceil(room_width / cell) + 4) runner_emit_column();

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
scroll_max = ::kernel::kernel_tuning("scroll_max", 14);
scroll_gain = ::kernel::kernel_tuning("scroll_gain", 0.0025);

// Metres already banked as score, so the run does not score them twice.
scored_to = 0;
