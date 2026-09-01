/// @function projectile_cooldown_make(shots_per_second)
/// @description State for a weapon that fires at a fixed rate.
function projectile_cooldown_make(shots_per_second) {
    var _rate = max(0.0001, shots_per_second);
    return { gap: 1 / _rate, left: 0 };
}

/// @function projectile_ready(cooldown)
/// @description Age the cooldown by one frame and report whether a shot is
/// allowed. Returns true at most once per gap however often it is asked,
/// so holding the fire key cannot outrun the rate.
function projectile_ready(cooldown) {
    cooldown.left = max(0, cooldown.left - delta_time / 1000000);
    if (cooldown.left > 0) return false;
    cooldown.left = cooldown.gap;
    return true;
}
