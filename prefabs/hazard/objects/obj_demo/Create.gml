x = 120;
y = 460;
respawn = hazard_make(x, y);

// Three spikes and two checkpoints along the way, so the checkpoint moving
// is visible rather than asserted.
instance_create_depth(360, 460, 0, obj_demo_spike);
instance_create_depth(600, 460, 0, obj_demo_spike);
instance_create_depth(840, 460, 0, obj_demo_spike);
checkpoints = [[480, 460], [720, 460]];
