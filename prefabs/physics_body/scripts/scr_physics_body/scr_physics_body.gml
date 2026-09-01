/// Keeping a Box2D body honest.
///
/// Every one of these is a bug found in a shipped jam game rather than a
/// hypothetical. A physics body does not behave like an instance you move:
/// writing `x` does nothing, resting bodies fall asleep, fast ones pass
/// through walls, and a "pause" that only skips your Step leaves the world
/// simulating underneath it.

/// @function phys_make(speed_cap)
/// @description Bookkeeping for one body: the speed ceiling, and the state
/// impact and stall detection need between frames. Call in Create.
function phys_make(speed_cap) {
    return {
        cap: speed_cap,
        prev_vx: 0,
        prev_vy: 0,
        stalled: 0,
        frozen: false,
        held_vx: 0,
        held_vy: 0,
    };
}

/// @function phys_speed()
/// @scope instance
/// @description How fast the calling body is going, in **pixels per step**.
///
/// GameMaker offers the same velocity twice: `phy_speed_*` in pixels per
/// step and `phy_linear_velocity_*` in pixels per second, a factor of
/// `room_speed` apart. Measured on the runner, setting a linear velocity of
/// 30 gives a `phy_speed` of 0.499 and moves the body 14.7px in 30 frames.
///
/// Everything here is per step, because every other speed in a GameMaker
/// game is — `motion`'s run speed, a bullet's travel, an enemy's chase.
/// A physics library quoting seconds while the rest of the catalog quotes
/// steps is how a launch speed of 22 ends up moving a ball a third of a
/// pixel a frame.
function phys_speed() {
    return point_distance(0, 0, phy_speed_x, phy_speed_y);
}

/// @function phys_clamp_speed(state)
/// @scope instance
/// @description Hold the body under its cap, keeping direction. Returns the
/// resulting speed.
///
/// `phy_bullet = true` is the first defence against a fast body passing
/// through a thin wall, and it is not sufficient on its own — a ball that
/// keeps gaining energy off bouncy surfaces eventually outruns it. This is
/// the backstop.
function phys_clamp_speed(state) {
    var _spd = phys_speed();
    if (_spd <= state.cap || _spd <= 0) return _spd;
    var _k = state.cap / _spd;
    phy_speed_x *= _k;
    phy_speed_y *= _k;
    return state.cap;
}

/// @function phys_nudge(direction, force)
/// @scope instance
/// @description Shove the body along a direction — what a stall recovery,
/// a bumper or a launcher does.
function phys_nudge(direction, force) {
    physics_apply_impulse(x, y,
        lengthdir_x(force, direction), lengthdir_y(force, direction));
}

/// @function phys_launch(direction, speed)
/// @scope instance
/// @description Set velocity outright rather than adding to it, so a serve
/// is the same however the body was moving beforehand. An impulse on a body
/// already travelling gives a different result each time.
function phys_launch(direction, speed) {
    phy_speed_x = lengthdir_x(speed, direction);
    phy_speed_y = lengthdir_y(speed, direction);
}

