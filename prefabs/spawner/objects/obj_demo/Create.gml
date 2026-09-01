// The kernel owns the run state, and `kernel_playing()` reads it. Without a
// boot it is simply not set, and the first object to ask dies with a bare
// "not set before reading it" naming a kernel script rather than the caller.
::kernel::kernel_boot();

// `spawns` ships as `noone` so a freshly applied recipe cannot spawn the
// wrong thing by accident. Pointing it at something is the one wiring step
// the prefab asks of you, and this demo is that step.
with (obj_spawner) {
    spawns = obj_mote;
    // The shipped interval is tuned for enemies you have to fight. A demo
    // wants a room with something in it, so this hurries the first waves
    // along: `interval` is what the alarm re-arms from, so both move.
    interval = 20;
    alarm[0] = interval;
}
