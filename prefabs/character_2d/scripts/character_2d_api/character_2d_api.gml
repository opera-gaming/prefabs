// character_2d's API, plus its ragdoll policy. The doll itself -- bodies,
// joints, the straightening motors and writing the solved pose back -- lives in
// the runtime behind rig_ragdoll_*; its collision layout is authored on the rig
// asset. What is here is when to drop the character, when it has settled, and
// which get-up clip to blend into.

// ---------------------------------------------------------------------------
// Public API. `_inst` is an obj_character instance.
// ---------------------------------------------------------------------------

/// Walk to room x `_x` (clamped to the walkable range), then idle. Ignored while
/// down, getting up or mid-jump.
function character_walk_to(_inst, _x) {
    with (_inst) {
        if (!is_undefined(ragdoll) || getting_up || jumping) return;
        walk_target = clamp(_x, walk_left, walk_right);
        walk_dir = sign(walk_target - rig_get_x(rig));
        if (walk_dir == 0) walk_target = undefined;
    }
}

/// Jump on the spot (the clip carries its own lift and a little travel), then
/// idle. Ignored while down, getting up or already jumping.
function character_jump(_inst) {
    with (_inst) {
        if (!is_undefined(ragdoll) || getting_up || jumping) return;
        walk_target = undefined;
        jumping = true;
        rig_set_clip(rig, clip_jump, false, blend_jump);
    }
}

/// Drop the character as a ragdoll, seeded from the pose on screen plus a shove
/// of `_ix`,`_iy` px per step (a hit's direction). It lies until still, then
/// gets up by itself where it fell. Returns false when it is already down.
function character_ragdoll(_inst, _ix = 0, _iy = 0) {
    with (_inst) {
        if (!is_undefined(ragdoll)) return false;
        jumping = false;
        getting_up = false;
        walk_target = undefined;
        ragdoll = character_ragdoll_start(rig, layer, _ix, _iy);
        if (is_undefined(ragdoll)) return false;
        // The capsule would stand in the doll's way.
        phy_active = false;
        character_ragdoll_arm_getup(ragdoll, ground_y);
        return true;
    }
}

/// Whether the character is a ragdoll right now.
function character_is_down(_inst) {
    return !is_undefined(_inst.ragdoll);
}

/// Re-skin: swap the rig asset for `_rig` (a RIG asset made with the
/// generating-rig-characters skill) where it stands, facing the same way, idling.
function character_set_rig(_inst, _rig) {
    with (_inst) {
        var _x = rig_get_x(rig), _f = rig_get_facing(rig);
        if (!is_undefined(ragdoll)) { character_ragdoll_stop(ragdoll); ragdoll = undefined; }
        rig_destroy(rig);
        rig_asset = _rig;
        rig = rig_create(_rig);
        rig_set_scale(rig, char_scale);
        rig_set_position(rig, _x, ground_y);
        rig_set_facing(rig, _f);
        rig_set_clip(rig, clip_idle, true);
        rig_set_root_motion(rig, true);
        getting_up = false; jumping = false; walk_target = undefined;
        phy_active = true;
    }
}

/// Whether a room point lands on the standing character: near any segment the
/// ragdoll would give a body, at the collider's own width.
function character_point_on(_inst, _px, _py) {
    var _seg = character_ragdoll_segments();
    for (var i = 0; i < array_length(_seg); i++) {
        var _d = rig_body_point_distance(_inst.rig, _seg[i], _px, _py);
        if (_d >= 0 && _d <= 24) return true;
    }
    return false;
}

/// The colliders the character's bodies can hit: a floor at `_ground_y` across
/// the room, walls at its edges, a ceiling. Made once per room (obj_solid is
/// what obj_ragdoll_part and obj_character have collision events for); a room
/// that already has an obj_solid floor -- the demo's -- is left alone.
function character_ensure_solids(_ground_y) {
    if (instance_exists(obj_solid)) return;
    // Scale goes in with the creation struct: a fixture is sized when the
    // instance is created, and image_xscale set afterwards does not resize it.
    var _t = 16;
    instance_create_layer(room_width * 0.5, _ground_y + _t * 0.5, layer, obj_solid,
                          { image_xscale: room_width, image_yscale: _t });
    instance_create_layer(_t * 0.5, room_height * 0.5, layer, obj_solid,
                          { image_xscale: _t, image_yscale: room_height });
    instance_create_layer(room_width - _t * 0.5, room_height * 0.5, layer, obj_solid,
                          { image_xscale: _t, image_yscale: room_height });
    instance_create_layer(room_width * 0.5, -_t * 0.5, layer, obj_solid,
                          { image_xscale: room_width, image_yscale: _t });
}

/// Live physics tuning, mirrored onto every doll. Gravity is the room's, the
/// rest the runtime's. Edit the fields to change the feel.
function character_ragdoll_tuning() {
    if (!variable_global_exists("character_2d_ragdoll_tuning")) {
        global.character_2d_ragdoll_tuning = {
            angular_damping:  0.4,
            linear_damping:  0.02,
            joint_damping:    1.5,    // torque per rad/s of relative joint spin
            rest_speed:      0.80,    // per-part px/step below which it counts as still
            rest_time:       0.50,    // seconds of stillness before it starts getting up
            blend_time:      0.35,    // seconds to cross-fade physics pose -> clip pose
        };
    }
    return global.character_2d_ragdoll_tuning;
}

// ---------------------------------------------------------------------------
// Internals: locomotion and the ragdoll state machine (run from obj_character).
// ---------------------------------------------------------------------------

/// Idle <-> walk, in the character's scope. A target turns it toward there and
/// crossfades the walk in; arriving (or passing it) crossfades the idle back.
/// The clip's root motion carries it, so nothing here moves the rig.
function character_locomotion(_inst) {
    with (_inst) {
        var _walking = rig_get_clip(rig) == clip_walk;
        if (is_undefined(walk_target)) {
            if (_walking) rig_set_clip(rig, clip_idle, true, blend_idle);
            return;
        }
        var _d = walk_target - rig_get_x(rig);
        // Arrived, or walked past it: a step is longer than the margin at speed.
        if (abs(_d) <= walk_stop || sign(_d) != walk_dir) {
            walk_target = undefined;
            rig_set_clip(rig, clip_idle, true, blend_idle);
            return;
        }
        rig_set_facing(rig, walk_dir);
        if (!_walking) rig_set_clip(rig, clip_walk, true, blend_walk);
    }
}

/// Pushes the tunable subset the runtime owns onto a live doll.
function character_ragdoll_apply_tuning(_rd) {
    if (_rd.doll < 0) return;
    var _t = character_ragdoll_tuning();
    rig_ragdoll_set_tuning(_rd.doll, "angular_damping", _t.angular_damping);
    rig_ragdoll_set_tuning(_rd.doll, "linear_damping", _t.linear_damping);
    rig_ragdoll_set_tuning(_rd.doll, "joint_damping", _t.joint_damping);
}

/// Segments to hit-test against. The rig knows its own bodies; this is only
/// the order they are checked in.
function character_ragdoll_segments() {
    return ["mixamorig:Hips", "mixamorig:Head", "mixamorig:LeftArm", "mixamorig:LeftForeArm",
            "mixamorig:RightArm", "mixamorig:RightForeArm", "mixamorig:LeftUpLeg",
            "mixamorig:LeftLeg", "mixamorig:LeftFoot", "mixamorig:RightUpLeg",
            "mixamorig:RightLeg", "mixamorig:RightFoot"];
}

/// Switches `_rig` to a ragdoll. `_ix`/`_iy` are an extra shove in px per step.
/// Returns undefined when the rig has no ragdoll layout.
function character_ragdoll_start(_rig, _layer, _ix = 0, _iy = 0) {
    var _doll = rig_ragdoll_create(_rig, obj_ragdoll_part, _layer, _ix, _iy, false);
    if (_doll < 0) return undefined;
    var _rd = { rig: _rig, doll: _doll, getup: undefined, still: 0, rising: false };
    character_ragdoll_apply_tuning(_rd);
    return _rd;
}

/// Arms getting up: once the doll has lain quiet for `rest_time` it hands
/// itself back to whichever get-up clip matches how it landed. `_ground_y` is
/// the floor it stands up on.
function character_ragdoll_arm_getup(_rd, _ground_y) {
    _rd.getup = _ground_y;
    _rd.still = 0;
}

/// One step of the state machine. "limp" while it lies there, "rising" while the
/// runtime fades it onto the clip, "done" the frame the rig is back on its own clock.
function character_ragdoll_update(_rd) {
    if (_rd.doll < 0 || !rig_ragdoll_exists(_rd.doll)) {
        _rd.doll = -1;
        return "done";
    }
    rig_ragdoll_step(_rd.doll);
    if (_rd.rising) return rig_ragdoll_exists(_rd.doll) ? "rising" : "done";

    if (!is_undefined(_rd.getup)) {
        var _tune = character_ragdoll_tuning();
        var _dt = 1 / max(game_get_speed(gamespeed_fps), 1);
        _rd.still = (rig_ragdoll_motion(_rd.doll) < _tune.rest_speed) ? _rd.still + _dt : 0;
        if (_rd.still >= _tune.rest_time) {
            var _clip = rig_ragdoll_face_down(_rd.doll) ? clip_getup_front : clip_getup_back;
            var _t0 = rig_get_marker_time(_clip, "rise");
            if (_t0 < 0) {
                show_error("get-up clip is missing its 'rise' marker: nothing to blend toward", true);
            }
            rig_ragdoll_blend_to_clip(_rd.doll, _clip, _t0, _tune.blend_time, _rd.getup);
            _rd.rising = true;
            return "rising";
        }
    }
    return "limp";
}

/// Drops the doll early -- on a reset, say. The runtime hands the rig back.
function character_ragdoll_stop(_rd) {
    if (_rd.doll < 0) return;
    if (rig_ragdoll_exists(_rd.doll)) rig_ragdoll_destroy(_rd.doll);
    _rd.doll = -1;
}
