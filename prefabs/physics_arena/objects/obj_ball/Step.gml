var _ctl = instance_find(obj_arena, 0);
if (_ctl == noone || !::kernel::kernel_playing()) exit;

// Impact first, before anything else touches the velocity.
var _hit = ::physics_body::phys_impact(body, 2);
if (_hit > 0) {
    squash = min(1, _hit / 30);
    var _break = break_impact;
    if (_hit >= _break) {
        // What the ball is actually touching, not whatever target happens to
        // be nearest. Targets sit at (480, 90) and (480, 450) and the wall
        // faces are ~50px beyond them, so "nearest within 60" scored a kill
        // for bouncing off the wall above a target without going near it.
        var _t = instance_place(x, y, obj_target);
        if (_t != noone) {
            ::kernel::kernel_score_add(target_score);
            ::feel::feel_pop(_t.x, _t.y, "+" +
                string(target_score), c_yellow);
            ::feel::feel_shake(0.2, 7);
            instance_destroy(_t);
        }
    }
}
squash *= 0.86;

::physics_body::phys_clamp_speed(body);

// A ball at rest in a corner ends no round.
if (::physics_body::phys_stalled(body, 1.5, 1.0)) {
    ::physics_body::phys_nudge(irandom(359), nudge_force);
}

// Bodies do escape, through a seam or at a speed the solver could not
// resolve. One that has left is gone unless something notices.
if (::physics_body::phys_out_of_bounds(90)) {
    // Not the room centre — a bumper is placed there. Pinning a dynamic body
    // inside a static one with restitution above 1 makes Box2D eject it hard,
    // and a `phy_bullet` ejected hard can leave the room again on the next
    // step: a pin/eject loop rather than a recovery.
    var _rx = room_width / 2;
    var _ry = room_height / 2;
    var _tries = 0;
    while (_tries < 16
        && (position_meeting(_rx, _ry, obj_bumper)
            || position_meeting(_rx, _ry, obj_target)
            || position_meeting(_rx, _ry, obj_wall))) {
        _rx = irandom_range(120, room_width - 120);
        _ry = irandom_range(120, room_height - 120);
        _tries += 1;
    }
    ::physics_body::phys_pin(_rx, _ry);
    ::physics_body::phys_launch(irandom(359), launch_speed);
}
