// Entering `play` resets score, combo and the run clock — see the kernel.
::kernel::kernel_state_set(::kernel::kernel_states().play);

// The ship and the boss are placed in rm_play — move either in an editor and
// the fight starts somewhere else with no code change.
survived = ::timer::timer_stopwatch();
tally = 0;
overlord = noone;

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
survive_score = ::kernel::kernel_tuning("survive_score", 5);
