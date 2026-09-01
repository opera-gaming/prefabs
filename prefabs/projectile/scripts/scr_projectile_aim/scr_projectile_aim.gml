/// @function projectile_aim(from_x, from_y, to_x, to_y)
/// @description The direction in degrees from one point to another — what
/// `projectile_launch` wants for a shot at a target that is standing still.
function projectile_aim(from_x, from_y, to_x, to_y) {
    return point_direction(from_x, from_y, to_x, to_y);
}

/// @function projectile_lead(from_x, from_y, target, bullet_speed)
/// @description Aim where a moving `target` will be rather than where it is.
/// Falls back to aiming straight at it when the target is faster than the
/// shot, which is the case where no interception exists.
///
/// Returns `-1` when there is nothing to shoot at — a destroyed target or a
/// non-positive speed. Check for it: every real direction is 0–359, and 0 is
/// due east, so returning 0 there fires a live shot to the right instead of
/// holding fire.
function projectile_lead(from_x, from_y, target, bullet_speed) {
    if (!instance_exists(target) || bullet_speed <= 0) {
        return -1;
    }
    var _straight = point_direction(from_x, from_y, target.x, target.y);
    // No interception exists once the target outruns the shot: the meeting
    // point solves behind the shooter and the extrapolation diverges, so the
    // turret would aim further and further from anything real.
    if (target.speed >= bullet_speed) {
        return _straight;
    }
    var _dist = point_distance(from_x, from_y, target.x, target.y);
    var _t = _dist / bullet_speed;
    var _tx = target.x + lengthdir_x(target.speed * _t, target.direction);
    var _ty = target.y + lengthdir_y(target.speed * _t, target.direction);
    return point_direction(from_x, from_y, _tx, _ty);
}

