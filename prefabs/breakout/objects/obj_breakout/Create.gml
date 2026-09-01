// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);

lives_left = ::kernel::kernel_tuning("lives", 3);
total_bricks = 0;
