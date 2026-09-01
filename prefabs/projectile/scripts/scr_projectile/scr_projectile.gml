/// Things that are fired, travel, and stop existing.
///
/// The lifetime is not decoration. A bullet that leaves the room without
/// being destroyed is still simulated, and a game that fires ten a second
/// accumulates thousands of them over a few minutes — the frame rate falls
/// away long after the mistake, which is what makes it hard to find.

/// @function projectile_launch(obj, from_x, from_y, dir, speed, seconds)
/// @description Create one at (from_x, from_y) travelling in `dir` degrees
/// at `speed` pixels a frame, dead after `seconds`. Returns the instance so
/// a caller can set damage or a colour on it.
function projectile_launch(obj, from_x, from_y, dir, speed, seconds) {
    var _p = instance_create_depth(from_x, from_y, 0, obj);
    _p.direction = dir;
    _p.speed = speed;
    _p.image_angle = dir;
    _p.projectile_life = seconds;
    return _p;
}

/// @function projectile_step(obj_hit)
/// @scope instance
/// @description Run from the projectile's own Step. Ages it, destroys it on
/// timeout or once it is fully outside the room, and returns the first
/// `obj_hit` it is touching — or `noone`. Destroying it on a hit is the
/// caller's choice, because a piercing shot is the same code minus that line.
function projectile_step(obj_hit) {
    projectile_life -= delta_time / 1000000;
    if (projectile_life <= 0 || projectile_offscreen()) {
        instance_destroy();
        return noone;
    }
    return obj_hit == noone ? noone : instance_place(x, y, obj_hit);
}

/// @function projectile_offscreen()
/// @scope instance
/// @description True once this instance is past every room edge by its own
/// sprite width, so something spawned just outside is not killed instantly.
function projectile_offscreen() {
    // A spriteless projectile has no width to measure, so assume a small
    // one — generous enough that a shot spawned just off-screen is not
    // destroyed before it enters.
    var _pad = sprite_exists(sprite_index) ? sprite_get_width(sprite_index) : 16;
    return x < -_pad || y < -_pad || x > room_width + _pad || y > room_height + _pad;
}

