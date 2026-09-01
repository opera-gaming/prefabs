::kernel::kernel_boot();
run = levels_make(0.3);

// A real game counts what the room holds — `instance_number(obj_coin)`. The
// demo has no pickups, so it asks for one press instead.
levels_gate(run, 1);
