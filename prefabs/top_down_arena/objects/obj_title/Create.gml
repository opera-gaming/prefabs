// One boot for the whole run. The kernel is persistent, so this happens
// once and every later room inherits the state it set up.
::kernel::kernel_boot();
::kernel::kernel_data_source(top_down_arena_data, top_down_arena_tuning());
::kernel::kernel_state_set(::kernel::kernel_states().title);
