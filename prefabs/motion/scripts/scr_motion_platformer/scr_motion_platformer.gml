/// @function motion_platformer_make(tuning)
/// @description State a jumping character needs between frames. Pass a
/// struct to override any of the defaults; the numbers are pixels and
/// frames, at the room's speed.
function motion_platformer_make(tuning = {}) {
    var _d = {
        run_speed: 4,
        gravity_per_frame: 0.5,
        fall_max: 12,
        jump_strength: 10,
        // Frames after walking off a ledge where a jump still counts.
        // Without it, players who press jump on the exact frame they
        // leave the ground get nothing and blame the controls.
        coyote_frames: 6,
        // Frames a jump press is remembered while still airborne, so
        // pressing slightly early lands as a jump on touchdown.
        buffer_frames: 6,
        // Extra launches allowed before touching ground again. 0 is a
        // plain jump, 1 is a double jump. Refilled on landing.
        air_jumps: 0,
        // Strength of those extra launches. 0 means "same as the first",
        // which is the usual choice; a smaller number makes the second
        // jump a top-up rather than a second full arc.
        air_jump_strength: 0,
        // A tile layer to collide against, alongside whatever `obj_solid`
        // the step is given. `motion_tilemap("Tiles")` produces one.
        // `noone` means instances are the only walls.
        tilemap: noone
    };
    var _keys = variable_struct_get_names(tuning);
    for (var i = 0; i < array_length(_keys); i++) {
        _d[$ _keys[i]] = tuning[$ _keys[i]];
    }
    _d.vy = 0;
    _d.on_ground = false;
    _d.coyote = 0;
    _d.buffer = 0;
    _d.spent_press = false;
    _d.air_left = _d.air_jumps;
    return _d;
}

/// @function motion_platformer_jump(state, strength)
/// @description Launch the body upward right now, whatever it was doing.
///
/// The hook for jumps the ground rules do not cover — wall jumps, a bounce
/// pad, a spring enemy. `motion_platformer_step` owns `vy`, so setting it
/// from outside fights the integrator on the next frame; this sets it the
/// way the step itself would.
///
/// **Not needed for a double jump.** That is `air_jumps: 1` on the tuning
/// struct — the counter, the strength and refilling on landing are already
/// in the step. Hand-rolling it here is the slower road to the same place,
/// and it has to re-solve the press-buffer interaction below.
///
/// `strength` is in the same units as `jump_strength` and is taken as a
/// magnitude, so passing a negative by mistake still goes up rather than
/// slamming the player into the floor.
function motion_platformer_jump(state, strength) {
    state.vy = -abs(strength);
    // Tell the step to ignore this frame's press. It re-arms `buffer` from the
    // same `jump_pressed` that triggered this call, so a double jump within
    // `buffer_frames` of the ground left a live buffer that spent itself the
    // moment `on_ground` refreshed `coyote` on landing — a third jump nobody
    // asked for.
    state.spent_press = true;
    // A jump that has just started is not standing on anything. Without
    // this the same press can be spent twice — once here and once by the
    // step's own coyote rule on the very next frame.
    state.on_ground = false;
    state.coyote = 0;
    state.buffer = 0;
    return state;
}

/// @function motion_platformer_step(state, obj_solid, dx, jump_held, jump_pressed)
/// @scope instance
/// @description One frame of run-and-jump against `obj_solid`. `dx` is
/// -1..1. Mutates and returns `state`.
///
/// Variable jump height comes from cutting upward velocity when the key
/// is released, not from a longer hold — that way a tap is always a small
/// hop and holding is always the full arc, at any frame rate.
///
/// Double jump is `air_jumps: 1` on the tuning struct, not code you write
/// here: the extra launches, their strength, and refilling them on landing
/// are all handled below.
function motion_platformer_step(state, obj_solid, dx, jump_held, jump_pressed) {
    motion_move_x(obj_solid, dx * state.run_speed, state.tilemap);

    state.vy = min(state.vy + state.gravity_per_frame, state.fall_max);

    if (jump_pressed && !state.spent_press) state.buffer = state.buffer_frames;
    else if (state.buffer > 0) state.buffer -= 1;
    state.spent_press = false;

    if (state.on_ground) state.coyote = state.coyote_frames;
    else if (state.coyote > 0) state.coyote -= 1;

    if (state.buffer > 0 && state.coyote > 0) {
        state.vy = -state.jump_strength;
        state.buffer = 0;
        state.coyote = 0;
    } else if (jump_pressed && state.air_left > 0) {
        // On the press itself, never out of the buffer: a buffered press is
        // there to become a ground jump a frame later, and spending it in
        // the air takes that away from a player who pressed slightly early.
        var _air = (state.air_jump_strength > 0) ? state.air_jump_strength : state.jump_strength;
        state.vy = -_air;
        state.buffer = 0;
        state.air_left -= 1;
    }
    if (state.vy < 0 && !jump_held) state.vy *= 0.5;

    var _hit = motion_move_y(obj_solid, state.vy, state.tilemap);
    // Ground is what is under the mover, not whether this frame's move was
    // blocked: the pixel step can stop a fraction short of a surface, and
    // falling that fraction later would read as a second landing.
    state.on_ground = state.vy >= 0 && motion_blocked(obj_solid, state.tilemap, x, y + 1);
    if (_hit) state.vy = 0;
    // Refill here rather than at the top, so the frame you land on is
    // already a frame you can jump from again.
    if (state.on_ground) state.air_left = state.air_jumps;

    return state;
}

/// @function motion_platformer_stomp(state, obj_target, bounce)
/// @scope instance
/// @description Land on something from above: returns the instance stomped,
/// or `noone`. Bounces off it and gives the air jump back, so a chain of
/// enemies reads as one move rather than several.
///
/// Only counts while falling and only from above, so walking into an enemy
/// is still walking into an enemy — which is the half that decides whether
/// this feels fair. `bounce` of 0 uses a little over half a jump.
///
/// **Call it before whatever kills the player on contact.** Landing on an
/// enemy is a frame where both are true, and the first test wins — put this
/// second and a stomp reads as a death every time.
///
/// The bounce is a launch like any other, so the variable-height rule applies
/// to it: `motion_platformer_step` halves upward velocity on every frame
/// `jump_held` is false, and a player who is not holding jump at the moment
/// of the stomp sees the arc cut to nothing. Count a few frames down after a
/// stomp and pass `jump_held` as true across them, and the bounce is one
/// fixed height rather than a coin flip on where the player's thumb was.
function motion_platformer_stomp(state, obj_target, bounce = 0) {
    if (state.vy <= 0) return noone;

    var _hit = instance_place(x, y, obj_target);
    if (_hit == noone) return noone;

    // Came down onto it rather than into its side: the feet have to be in
    // the target's upper band at the moment of contact.
    if (bbox_bottom > _hit.bbox_top + (_hit.bbox_bottom - _hit.bbox_top) * 0.5) {
        return noone;
    }

    state.vy = -((bounce > 0) ? bounce : state.jump_strength * 0.6);
    state.air_left = state.air_jumps;
    state.on_ground = false;
    return _hit;
}
