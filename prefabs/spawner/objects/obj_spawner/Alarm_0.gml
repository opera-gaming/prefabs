var _t = spawner_tuning();

// The cap is checked at spawn time rather than by pausing the timer, so
// the wave keeps its rhythm and simply skips while the room is full.
if (spawns != noone && instance_number(spawns) < _t.population_cap) {
    var _x = irandom_range(32, room_width - 32);
    instance_create_layer(_x, -32, layer, spawns);
    spawned += 1;
}

alarm[0] = interval;
