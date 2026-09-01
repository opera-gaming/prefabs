// The kernel owns run state, score and save. It has to be booted before
// anything reads them — obj_kernel's own Step does, on frame one.
::kernel::kernel_boot();

// The level is placed in rm_level, so a block can be dragged in an editor.
// The terrain is the room's `Tiles` layer and is the only copy of the shape —
// read and edit it with `gmx autotile shape rm_level`.
global.coins_total = 0;
global.coins_taken = 0;
