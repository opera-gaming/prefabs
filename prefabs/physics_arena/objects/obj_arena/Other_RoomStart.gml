// Counted here, not in Create: Create runs as each instance is made, so a
// controller placed first in the layer would count a room that is still
// half-built. Room Start runs once every instance exists.
total_targets = instance_number(obj_target);
