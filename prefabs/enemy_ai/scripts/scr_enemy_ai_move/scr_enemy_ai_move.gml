/// @function ai_chase(state, target_x, target_y)
/// @scope instance
/// @description Move straight at the target at the state's speed.
function ai_chase(state, target_x, target_y) {
    ai_move_towards(state, target_x, target_y, 1);
}

/// @function ai_flee(state, target_x, target_y)
/// @scope instance
/// @description Move directly away from the target instead.
function ai_flee(state, target_x, target_y) {
    ai_move_towards(state, target_x, target_y, -1);
}

/// @function ai_move_towards(state, target_x, target_y, sign)
/// @scope instance
/// @description The shared half of chase and flee. `sign` is 1 towards, -1
/// away. Stops dead on arrival rather than jittering across the target,
/// which is what a bare `move_towards_point` does at close range.
function ai_move_towards(state, target_x, target_y, sign) {
    var _dist = point_distance(x, y, target_x, target_y);
    if (sign > 0 && _dist <= state.speed) {
        x = target_x;
        y = target_y;
        return;
    }
    var _dir = point_direction(x, y, target_x, target_y) + (sign > 0 ? 0 : 180);
    x += lengthdir_x(state.speed, _dir);
    y += lengthdir_y(state.speed, _dir);
}

/// @function ai_wander(state, hold_seconds)
/// @scope instance
/// @description Drift, changing direction every `hold_seconds` and turning
/// back at the room edge. What an enemy does before it has noticed anything.
function ai_wander(state, hold_seconds) {
    state.wander_left -= delta_time / 1000000;
    if (state.wander_left <= 0) {
        state.wander_left = hold_seconds;
        state.wander_dir = irandom(359);
    }
    var _nx = x + lengthdir_x(state.speed, state.wander_dir);
    var _ny = y + lengthdir_y(state.speed, state.wander_dir);
    if (_nx < 0 || _nx > room_width) state.wander_dir = 180 - state.wander_dir;
    if (_ny < 0 || _ny > room_height) state.wander_dir = -state.wander_dir;
    x = clamp(_nx, 0, room_width);
    y = clamp(_ny, 0, room_height);
}

/// @function ai_separate(state, obj_peers, spacing)
/// @scope instance
/// @description Push away from other `obj_peers` that are closer than
/// `spacing`. Without it a group of chasers converges into a single stack
/// that reads as one enemy and lands several hits at once.
function ai_separate(state, obj_peers, spacing) {
    // Half the overlap each, because both instances get pushed — a full
    // correction per pair doubles the force and the group jitters.
    var _share = 0.5;
    with (obj_peers) {
        if (id == other.id) continue;
        var _d = point_distance(x, y, other.x, other.y);
        if (_d >= spacing || _d == 0) continue;
        var _push = point_direction(x, y, other.x, other.y);
        other.x += lengthdir_x((spacing - _d) * _share, _push);
        other.y += lengthdir_y((spacing - _d) * _share, _push);
    }
}
