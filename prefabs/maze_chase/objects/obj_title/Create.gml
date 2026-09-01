// One boot for the whole run. The kernel is persistent, so this happens
// once and every later room inherits the state it set up.
::kernel::kernel_boot();
::kernel::kernel_data_source(maze_chase_data, maze_chase_tuning());
::kernel::kernel_state_set(::kernel::kernel_states().title);
::kernel::kernel_hud_visible(false);
