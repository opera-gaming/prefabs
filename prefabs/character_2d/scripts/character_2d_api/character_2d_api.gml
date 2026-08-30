// character_2d's API, plus its ragdoll policy. The doll itself lives in the
// runtime behind rig_ragdoll_* (layout authored on the rig asset); here is when
// to drop the character, when it has settled, and which get-up clip to blend into.

// ---------------------------------------------------------------------------
// Public API. `_inst` is an obj_character instance.
// ---------------------------------------------------------------------------

/// Walk (or run, with `_run`) to room x `_x` (clamped to the walkable range), then
/// idle. Ignored while down, getting up or kicking.
function character_walk_to(_inst, _x, _run = false) {
    with (_inst) {
        if (!is_undefined(ragdoll) || getting_up || kicking) return;
        // Asked for in the air: kept, and walked to once landed.
        walk_target = clamp(_x, walk_left, walk_right);
        walk_run = _run;
        walk_dir = sign(walk_target - rig_get_x(rig));
        if (walk_dir == 0) walk_target = undefined;
    }
}

/// Jump up and forward the way the character faces (jump_height_m,
/// jump_forward_m), landing on whatever is under it. Ignored while down,
/// getting up or already jumping.
function character_jump(_inst) {
    with (_inst) {
        if (!is_undefined(ragdoll) || getting_up || jumping) return;
        // Up and forward, the way it faces; a walk's own speed if that is faster.
        vx = max(jump_forward_m * 300 * char_scale, rig_get_clip(rig) == clip_walk ? rig_get_speed(rig) : 0) * facing;
        walk_target = undefined;
        jumping = true;
        jump_phase = "takeoff";
        rig_set_root_motion(rig, false);
        rig_set_clip(rig, clip_jump, false, blend_jump);
        rig_play_to_marker(rig, "airborne");
    }
}

/// A kick where it stands, facing as it faces, then idle. Ignored while down,
/// getting up, mid-jump or already kicking.
function character_kick(_inst) {
    with (_inst) {
        if (!is_undefined(ragdoll) || getting_up || jumping || kicking) return;
        walk_target = undefined;
        kicking = true;
        rig_set_clip(rig, clip_kick, false, blend_kick);
    }
}

/// The other character a kick lands on this step, or noone: at the kick clip's `hit`
/// markers the leading foot is tested against every other character's body, `_r` px wide.
function character_kick_hit(_inst, _r = 24) {
    with (_inst) {
        if (!kicking || !array_contains(markers_fired, "hit")) return noone;
        var _hx = rig_get_bone_x(rig, "mixamorig:Hips");
        var _lx = rig_get_bone_x(rig, "mixamorig:LeftFoot"), _rx = rig_get_bone_x(rig, "mixamorig:RightFoot");
        var _lead = (_lx - _hx) * facing > (_rx - _hx) * facing ? "mixamorig:LeftFoot" : "mixamorig:RightFoot";
        var _fx = rig_get_bone_x(rig, _lead), _fy = rig_get_bone_y(rig, _lead);
        var _me = id;
        with (obj_character) {
            if (id != _me && !is_undefined(character_hit_test(id, _fx, _fy, _r))) return id;
        }
        return noone;
    }
}

/// Draw the character white for `_secs` seconds (a hit, a pickup): solid, or blinking
/// with `_blink` seconds per on/off phase.
function character_flash(_inst, _secs = 0.3, _blink = 0) {
    _inst.flash = _secs;
    _inst.flash_blink = _blink;
}

/// Start falling from where the character is: straight into the airborne part of
/// the jump, keeping any walking speed, landing when the ground probe says so.
function character_fall(_inst) {
    with (_inst) {
        if (!is_undefined(ragdoll) || getting_up || jumping) return;
        vx = rig_get_clip(rig) == clip_walk ? rig_get_speed(rig) * walk_dir : 0;
        vy = 0;
        walk_target = undefined;
        jumping = true;
        jump_phase = "air";
        rig_set_root_motion(rig, false);
        // Into the held airborne frame: seek just short of the marker and stop on it.
        rig_set_clip(rig, clip_jump, false, blend_air);
        rig_set_clip_time(rig, rig_get_marker_time(clip_jump, "airborne") - 0.01);
        rig_play_to_marker(rig, "airborne");
    }
}

/// Whether moving the body from feet at `_from_x` to `_x` (feet at `_y`) runs it into
/// the side of a solid: a wall, or a platform it is beside. A solid the body already
/// overlapped at `_from_x` does not count, so it can pass up through a platform.
function character_blocked_at(_inst, _from_x, _x, _y) {
    var _hw = _inst.char_height * 0.18;
    var _top = _y - _inst.char_height * 0.95, _bot = _y - 6;
    var _objs = [obj_solid];
    if (variable_global_exists("sidescroller_solids")) array_push(_objs, global.sidescroller_solids);
    var _hit = false;
    for (var k = 0; k < array_length(_objs) && !_hit; k++) {
        with (_objs[k]) {
            var _l = x - image_xscale * 0.5, _r = x + image_xscale * 0.5;
            var _t = y - image_yscale * 0.5, _b = y + image_yscale * 0.5;
            if (_bot <= _t || _top >= _b) continue;
            var _now = _x + _hw > _l && _x - _hw < _r;
            var _before = _from_x + _hw > _l && _from_x - _hw < _r;
            if (_now && !_before) { _hit = true; break; }
        }
    }
    return _hit;
}

/// The ground under a point: the highest top at or below `_y` among the world's
/// solids (its floor and walls, i.e. platforms) and the character's own, under
/// `_x`; the flat ground line when nothing is closer.
function character_ground_below(_inst, _x, _y) {
    var _best = _inst.floor_y;
    var _objs = [obj_solid];
    if (variable_global_exists("sidescroller_solids")) array_push(_objs, global.sidescroller_solids);
    for (var k = 0; k < array_length(_objs); k++) {
        with (_objs[k]) {
            // A 1x1 box scaled per instance, origin at its centre.
            var _top = y - image_yscale * 0.5;
            if (_x >= x - image_xscale * 0.5 && _x <= x + image_xscale * 0.5 && _top >= _y - 4 && _top < _best) _best = _top;
        }
    }
    return _best;
}

/// Knocks the character over. `_ix`/`_iy` are a shove in px per step: on the
/// whole doll, or on `_bone`'s body alone when one is named (a hit to the head).
function character_ragdoll(_inst, _ix = 0, _iy = 0, _bone = undefined) {
    with (_inst) {
        if (!is_undefined(ragdoll)) return false;
        jumping = false;
        getting_up = false;
        walk_target = undefined;
        var _whole = is_undefined(_bone);
        ragdoll = character_ragdoll_start(rig, layer, _whole ? _ix : 0, _whole ? _iy : 0);
        if (is_undefined(ragdoll)) return false;
        if (!_whole) {
            var _part = rig_ragdoll_part(ragdoll.doll, _bone);
            if (_part != noone) { _part.phy_speed_x += _ix; _part.phy_speed_y += _iy; }
        }
        // The capsule would stand in the doll's way.
        phy_active = false;
        character_ragdoll_arm_getup(ragdoll, ground_y);
        return true;
    }
}

/// Which body of the character a point within `_r` px touches, in its pose right
/// now: the bone's name, to hand to character_ragdoll, or undefined for a miss.
function character_hit_test(_inst, _x, _y, _r) {
    var _segs = character_ragdoll_segments();
    for (var i = 0; i < array_length(_segs); i++) {
        if (rig_body_point_distance(_inst.rig, _segs[i], _x, _y) < _r) return _segs[i];
    }
    return undefined;
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
    // The world's platforms too, box for box, so a ragdoll lands on them.
    if (variable_global_exists("sidescroller_solids")) {
        with (global.sidescroller_solids) {
            instance_create_layer(x, y, other.layer, obj_solid, { image_xscale: image_xscale, image_yscale: image_yscale });
        }
    }
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
        var _clip = rig_get_clip(rig);
        var _walking = _clip == clip_walk || _clip == clip_run;
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
        facing = walk_dir;
        rig_set_facing(rig, walk_dir);
        var _want = walk_run ? clip_run : clip_walk;
        if (_clip != _want) {
            // Walk <-> run: start the new cycle at the phase the old one is at, measured from
            // the left foot's plant where both clips mark it, so the crossfade keeps the stride.
            var _phase = -1;
            if (_walking) {
                var _m0 = rig_get_marker_time(_clip, "left-foot"), _m1 = rig_get_marker_time(_want, "left-foot");
                _phase = (rig_get_clip_time(rig) - max(_m0, 0)) / rig_get_clip_length(rig);
                _phase = [_phase, max(_m1, 0)];
            }
            rig_set_clip(rig, _want, true, walk_run ? blend_run : blend_walk);
            if (is_array(_phase)) {
                var _len = rig_get_clip_length(rig);
                var _t = _phase[1] + _phase[0] * _len;
                rig_set_clip_time(rig, _t - floor(_t / _len) * _len);
            }
        }
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
