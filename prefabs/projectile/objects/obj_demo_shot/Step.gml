var _hit = projectile_step(obj_demo_target);
if (_hit != noone) {
    _hit.flash = 0.2;
    instance_destroy();
}
