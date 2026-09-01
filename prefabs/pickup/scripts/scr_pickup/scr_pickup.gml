/// Things lying on the floor that the player walks into.
///
/// Distance from the collector rather than a collision mask, so a pickup can
/// be drawn rather than sprited, and so the magnet radius and the grab radius
/// are the same idea measured twice.

/// @function pickup_make(grab, magnet, pull)
/// @description Pickup state: collected within `grab` pixels, drawn towards
/// the collector from `magnet` pixels at `pull` pixels a frame. Pass a magnet
/// of 0 for one that stays put.
function pickup_make(grab, magnet, pull) {
    return { grab: grab, magnet: magnet, pull: pull, taken: false };
}

/// @function pickup_step(state, obj_collector)
/// @scope instance
/// @description Run from the pickup's own Step. Drifts towards the nearest
/// collector once inside the magnet radius and returns the collector that
/// took it, or `noone`. Does not destroy the instance — scoring, a sound and
/// a popup usually want to happen first.
function pickup_step(state, obj_collector) {
    if (state.taken) return noone;
    var _who = instance_nearest(x, y, obj_collector);
    if (_who == noone) return noone;

    var _dist = point_distance(x, y, _who.x, _who.y);
    if (_dist <= state.grab) {
        state.taken = true;
        return _who;
    }
    if (state.magnet > state.grab && _dist <= state.magnet) {
        // Faster the closer it gets, so a near miss still resolves quickly
        // instead of trailing the player at a fixed distance forever.
        // A floor under the pull, so a pickup at the very edge of the
        // magnet still closes instead of trailing the player forever.
        var _floor = state.pull * 0.35;
        var _speed = state.pull * (1 - (_dist - state.grab)
            / max(1, state.magnet - state.grab)) + _floor;
        var _dir = point_direction(x, y, _who.x, _who.y);
        x += lengthdir_x(_speed, _dir);
        y += lengthdir_y(_speed, _dir);
    }
    return noone;
}

/// @function pickup_bob(height, speed)
/// @description A vertical offset to add at draw time, so a pickup reads as
/// loose on the floor rather than painted onto it. Purely cosmetic — it does
/// not move the instance, so it cannot drift it out of grab range.
function pickup_bob(height, speed) {
    return sin(current_time / 1000 * speed) * height;
}

