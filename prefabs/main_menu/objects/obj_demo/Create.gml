// The kernel owns the run state, and `kernel_playing()` reads it. Without a
// boot it is simply not set, and the first object to ask dies with a bare
// "not set before reading it" naming a kernel script rather than the caller.
::kernel::kernel_boot();
