/// @function phys_freeze(state)
/// @scope instance
/// @description Stop the body and remember its velocity. Gating your own
/// Step is not a pause: the physics world keeps integrating, so a "paused"
/// body keeps drifting and colliding.
function phys_freeze(state) {
    if (state.frozen) return;
    state.held_vx = phy_speed_x;
    state.held_vy = phy_speed_y;
    phy_speed_x = 0;
    phy_speed_y = 0;
    phy_angular_velocity = 0;
    state.frozen = true;
}

/// @function phys_thaw(state)
/// @scope instance
/// @description Give the velocity back, so a pause does not cost momentum.
function phys_thaw(state) {
    if (!state.frozen) return;
    phy_speed_x = state.held_vx;
    phy_speed_y = state.held_vy;
    state.frozen = false;
}

/// @function phys_pin(px, py)
/// @scope instance
/// @description Hold the body at a point — carried, docked, held before a
/// serve. Writing `x` and `y` does nothing to a physics body: the world
/// overwrites them from its own position every step. Teleport the body and
/// zero the velocity, every frame, or it drifts away by whatever it
/// accumulated in between.
function phys_pin(px, py) {
    phy_position_x = px;
    phy_position_y = py;
    phy_speed_x = 0;
    phy_speed_y = 0;
    phy_angular_velocity = 0;
}

