var _who = pickup_step(coin, obj_demo);
if (_who != noone) {
    _who.taken += 1;
    instance_destroy();
}
