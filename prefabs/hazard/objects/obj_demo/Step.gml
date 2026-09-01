hazard_step(respawn);

var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
x = clamp(x + _dx * 4, 0, room_width);

for (var i = 0; i < array_length(checkpoints); i++) {
    var _c = checkpoints[i];
    if (abs(x - _c[0]) < 16) hazard_checkpoint(respawn, _c[0], _c[1]);
}

// The grace window is what stops a respawn onto a spike costing every life
// at once.
if (!hazard_safe(respawn) && hazard_touching(obj_demo_spike) != noone) {
    hazard_respawn(respawn, 1.2);
}
