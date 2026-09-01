// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);
::kernel::kernel_hud_visible(false);

var _t = top_down_arena_tuning();
curve = ::wave::wave_make(
    _t.spawn_interval, _t.spawn_scale, _t.spawn_floor, _t.wave_seconds);
