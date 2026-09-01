// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);

clock = ::timer::timer_countdown(::kernel::kernel_tuning("round_seconds", 45));
total_targets = 0;
