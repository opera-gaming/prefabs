kernel_tick();

// Pause is owned here rather than by any pack: a pack gates on
// kernel_playing(), so toggling this is all pausing means.
if (global.kernel_pause && kernel_action_pressed("pause")) {
    var _s = kernel_states();
    if (kernel_state() == _s.play)  kernel_state_set(_s.pause);
    else if (kernel_state() == _s.pause) kernel_state_set(_s.play);
}
