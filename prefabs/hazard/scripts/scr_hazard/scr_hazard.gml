/// Spikes, pits and the place you come back to.
///
/// A hazard without a checkpoint is a hazard that sends the player to the
/// start of the level, and a level that punishes a mistake with three
/// minutes of walking is one they stop playing rather than one they master.

/// @function hazard_make(spawn_x, spawn_y)
/// @description Respawn state anchored at the level's start. Update it with
/// `hazard_checkpoint` as the player passes one.
function hazard_make(spawn_x, spawn_y) {
    return { x: spawn_x, y: spawn_y, deaths: 0, since: 0 };
}

/// @function hazard_touching(obj_hazard)
/// @scope instance
/// @description The hazard instance this one is overlapping, or `noone`.
function hazard_touching(obj_hazard) {
    return instance_place(x, y, obj_hazard);
}

/// @function hazard_step(state)
/// @description Count the respawn grace down. Call once a frame.
function hazard_step(state) {
    if (state.since > 0) {
        state.since = max(0, state.since - delta_time / 1000000);
    }
}

/// @function hazard_safe(state)
/// @description True while the respawn grace is still running — do not
/// apply damage, and flash the sprite so the player knows why.
function hazard_safe(state) {
    return state.since > 0;
}

/// @function hazard_knockback(from_x, from_y, force)
/// @scope instance
/// @description Shove the calling instance away from a point. What a hazard
/// that hurts rather than kills should do, so the player is not left
/// standing in it taking a hit per frame.
function hazard_knockback(from_x, from_y, force) {
    var _dir = point_direction(from_x, from_y, x, y);
    x = clamp(x + lengthdir_x(force, _dir), 0, room_width);
    y = clamp(y + lengthdir_y(force, _dir), 0, room_height);
}

/// @function hazard_fell_out(margin)
/// @scope instance
/// @description Whether the calling instance has fallen below the room by
/// `margin`. The pit that is not an object.
function hazard_fell_out(margin) {
    return y > room_height + margin;
}

