// Resolved here, not in Create: Create runs as each instance is made, so a
// controller placed first in the layer would look for a room still half-built.
overlord = instance_find(obj_boss, 0);
