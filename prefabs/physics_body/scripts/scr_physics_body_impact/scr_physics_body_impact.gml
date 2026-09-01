/// @function phys_impact(state, threshold)
/// @scope instance
/// @description How hard the body just hit something, or 0 for no impact.
///
/// Measured as how much the velocity *changed* this frame. That beats a
/// collision event for feedback, because it fires once per bounce carrying
/// a magnitude rather than once per frame of contact carrying none.
///
/// It is a delta rather than a direction reversal deliberately. A reversal
/// test — this frame's velocity pointing against last frame's — misses the
/// common case: a body travelling at 45° that bounces off one axis has
/// exactly reversed one component and kept the other, and the two cancel to
/// a dot product of zero. Only a near head-on hit registers, which is why a
/// game built that way feels like it only sometimes notices walls.
///
/// Call once a frame, before anything else changes the velocity.
function phys_impact(state, threshold) {
    var _vx = phy_speed_x;
    var _vy = phy_speed_y;
    var _change = point_distance(state.prev_vx, state.prev_vy, _vx, _vy);
    state.prev_vx = _vx;
    state.prev_vy = _vy;
    return _change >= threshold ? _change : 0;
}

/// @function phys_stalled(state, min_speed, seconds)
/// @scope instance
/// @description True once the body has been slower than `min_speed` for
/// `seconds` without interruption, and resets when it is.
///
/// A physics game needs this because a ball can come to rest somewhere the
/// player cannot reach it, and the run then never ends — the one failure a
/// playtest finds and a test suite does not.
function phys_stalled(state, min_speed, seconds) {
    if (phys_speed() >= min_speed) {
        state.stalled = 0;
        return false;
    }
    state.stalled += delta_time / 1000000;
    if (state.stalled < seconds) return false;
    state.stalled = 0;
    return true;
}

/// @function phys_out_of_bounds(margin)
/// @scope instance
/// @description Whether the body has left the room by `margin`. Bodies do
/// escape — through a seam between two walls, or at a speed the solver
/// could not resolve — and one that has left is gone for good unless
/// something notices.
function phys_out_of_bounds(margin) {
    return x < -margin || y < -margin
        || x > room_width + margin || y > room_height + margin;
}
