// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);

cell = ::kernel::kernel_tuning("cell", 32);
total_dots = 0;
nav = ::pathgrid::pathgrid_make(1, 1, cell);
