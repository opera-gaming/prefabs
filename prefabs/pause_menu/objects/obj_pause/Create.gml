// This object owns pausing, so the kernel's own must stand down —
// otherwise one keypress drives two pause systems at once.
::kernel::kernel_pause_enabled(false);

paused = false;
ramp = 0;
snap = -1;
// Guard against the keypress that opened the menu also closing it on the
// very next frame.
age = 0;
