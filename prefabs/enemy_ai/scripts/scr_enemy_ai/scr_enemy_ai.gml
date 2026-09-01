/// What an enemy does when it can see you, and what it does when it cannot.
///
/// One state field and a handful of movements, because the interesting part
/// of enemy behaviour is the switching, not the moving. Everything here acts
/// on the calling instance, so it goes in the enemy's own Step.

/// @function ai_make(speed, sight)
/// @description Enemy state: how fast it moves and how far it can see. Starts
/// idle, with no waypoints.
function ai_make(speed, sight) {
    return {
        speed: speed,
        sight: sight,
        mode: "idle",
        wander_dir: irandom(359),
        wander_left: 0,
        route: [],
        leg: 0,
    };
}

/// @function ai_sees(state, target_x, target_y)
/// @scope instance
/// @description True when the target is inside the sight radius. Distance
/// only — pass through `ai_has_line_of_sight` as well if walls should block.
function ai_sees(state, target_x, target_y) {
    return point_distance(x, y, target_x, target_y) <= state.sight;
}

/// @function ai_has_line_of_sight(target_x, target_y, obj_solid)
/// @scope instance
/// @description True when nothing solid stands between here and there.
function ai_has_line_of_sight(target_x, target_y, obj_solid) {
    if (obj_solid == noone) return true;
    return !collision_line(x, y, target_x, target_y, obj_solid, true, true);
}

