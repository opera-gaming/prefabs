var _ctl = instance_find(obj_runner, 0);
if (_ctl == noone || !::kernel::kernel_playing()) exit;

// The world moves, not the player. Tiles are destroyed once past the left
// edge rather than accumulating for the length of the run.
x -= _ctl.scroll;
if (x < -sprite_width) instance_destroy();
