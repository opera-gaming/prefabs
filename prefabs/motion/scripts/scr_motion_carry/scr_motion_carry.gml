/// Carrying a rider, which is the whole of what makes a moving platform
/// different from a wall that happens to move.

/// @function motion_carry(obj_rider, dx, dy, obj_solid, tilemap)
/// @scope instance
/// @description Move this instance by (`dx`, `dy`) and take whatever is
/// standing on it along. Call it from the platform's Step *before* the
/// rider takes its own step, so the rider resolves its gravity against
/// where the platform now is rather than where it was.
///
/// Riders are found by their feet, not by overlap: something standing on a
/// platform is not touching it, it is one pixel above. Each rider is moved
/// through `motion_move_x`/`motion_move_y`, so a platform that shoves a
/// rider into a wall leaves it flush against the wall instead of inside it.
///
/// Which of the two moves first depends on the sign of `dy`, and getting it
/// wrong fails silently in one direction only:
///
/// - Going **down or sideways** the platform leads. A rider stepped down
///   first is stopped by the platform still sitting under its feet, and
///   the platform then slides out from under it.
/// - Going **up** the rider leads. Move the platform first and it is now
///   overlapping the rider by `|dy|` pixels; if the rider's own move is
///   then blocked — a ceiling, another platform — the step-in loop finds
///   it already overlapping at one pixel and gives up, leaving it embedded
///   and pushed further in on every frame after.
///
/// Returns the number of riders carried.
function motion_carry(obj_rider, dx, dy, obj_solid, tilemap = noone) {
    // Collected before moving: once this instance has moved, the riders are
    // no longer over it and the same test finds nobody.
    var _riders = [];
    with (obj_rider) {
        if (place_meeting(x, y + 1, other.id)) array_push(_riders, id);
    }

    var _count = array_length(_riders);

    // Rising: the riders go first, so the platform never moves into them.
    if (dy < 0) {
        for (var i = 0; i < _count; i++) {
            with (_riders[i]) motion_move_y(obj_solid, dy, tilemap);
        }
    }

    x += dx;
    y += dy;

    // Falling or level: the platform has moved out of the way, so the
    // riders can follow it down without being blocked by it.
    for (var i = 0; i < _count; i++) {
        with (_riders[i]) {
            motion_move_x(obj_solid, dx, tilemap);
            if (dy > 0) motion_move_y(obj_solid, dy, tilemap);
        }
    }
    return _count;
}
