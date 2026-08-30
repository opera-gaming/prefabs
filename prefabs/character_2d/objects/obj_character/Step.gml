var dt = delta_time / 1000000;
var _down = is_undefined(ragdoll) && !getting_up;   // on its feet and in control

// --- input: a held finger is walked (far: run) or jumped towards; on the body it kicks;
// --- below the feet it is the game's ------------------------------------------------------
if (tap_control && _down) {
    var _px = mouse_x, _py = mouse_y;
    var _cx = rig_get_x(rig), _cy = rig_get_y(rig);
    if (mouse_check_button_pressed(mb_left) && character_point_on(id, _px, _py)) {
        character_kick(id);
    } else if (mouse_check_button(mb_left) && !kicking) {
        var _near = abs(_px - _cx) < char_height * 0.6;
        if (_py > _cy + 10 && _near) {
            // Below the feet: left to the game (a throw, a dash...).
        } else if (_py < _cy - char_height) {
            if (!jumping) {
                if (!_near) { facing = sign(_px - _cx); rig_set_facing(rig, facing); }
                character_jump(id);
            }
        } else if (!jumping) {
            if (abs(_px - _cx) > walk_stop) {
                character_walk_to(id, _px, abs(_px - _cx) > run_distance_m * 300 * char_scale);
            } else {
                walk_target = undefined;   // caught up: idle under the finger
            }
        }
    } else if (mouse_check_button_released(mb_left) && !jumping) {
        walk_target = undefined;
    }
}

// --- animation & motion ------------------------------------------------------
flash = max(0, flash - dt);
markers_fired = [];
if (is_undefined(ragdoll)) {
    rig_update(rig, dt);
    markers_fired = rig_poll_markers(rig);
    if (getting_up) {
        // Planted until the idle has actually taken over: the queue crossfades
        // it in at the `upright` marker, so there is nothing to do but wait.
        if (rig_get_clip(rig) == clip_idle) {
            getting_up = false;
            phy_active = true;
        }
    } else if (jumping) {
        // Three parts of clip_jump, chosen by the vertical motion: the takeoff runs
        // to the `airborne` marker and holds that frame while in the air; the
        // landing plays from `land` once the feet meet the ground.
        switch (jump_phase) {
        case "takeoff":
            if (rig_clip_finished(rig)) {   // held at `airborne`
                vy = -sqrt(2 * jump_gravity * jump_height_m * 300 * char_scale);
                jump_phase = "air";
            }
            break;
        case "air":
            var _y = rig_get_y(rig) + vy * dt;
            vy += jump_gravity * dt;
            var _nx = rig_get_x(rig) + vx * dt;
            if (character_blocked_at(id, rig_get_x(rig), _nx, _y)) { _nx = rig_get_x(rig); vx = 0; }
            // Probe from where the feet were, so a top crossed within this step still lands.
            var _gy = character_ground_below(id, _nx, rig_get_y(rig));
            if (vy > 0 && _y >= _gy) {
                _y = _gy;
                ground_y = _gy;
                jump_phase = "land";
                rig_set_clip(rig, clip_jump, false, blend_land);
                rig_set_clip_time(rig, rig_get_marker_time(clip_jump, "land"));
            }
            rig_set_position(rig, _nx, _y);
            break;
        case "land":
            if (rig_clip_finished(rig)) {
                jumping = false;
                rig_set_root_motion(rig, true);
                rig_set_clip(rig, clip_idle, true, blend_idle);
            }
            break;
        }
    } else if (kicking) {
        if (rig_clip_finished(rig)) {
            kicking = false;
            rig_set_clip(rig, clip_idle, true, blend_idle);
        }
    } else {
        var _px = rig_get_x(rig);
        character_locomotion(id);
        // Walked into a wall or a platform's side: stay put and stop.
        if (character_blocked_at(id, _px, rig_get_x(rig), rig_get_y(rig))) {
            rig_set_position(rig, _px, rig_get_y(rig));
            walk_target = undefined;
            rig_set_clip(rig, clip_idle, true, blend_idle);
        }
        // Walked off an edge: nothing under the feet any more.
        if (character_ground_below(id, rig_get_x(rig), rig_get_y(rig)) > rig_get_y(rig) + 2) character_fall(id);
    }
    // The capsule rides on the rig. Kinematic, so this is a teleport, not a push.
    phy_position_x = rig_get_x(rig);
    phy_position_y = rig_get_y(rig);
    x = phy_position_x;
    y = phy_position_y;
}

// --- camera hand-off -------------------------------------------------------
// The hips, walking, jumping or ragdolled, so a limb flung out to arm's length
// does not drag the view. Only when a world is listening, and only the one the camera is for.
if (camera_focus && variable_global_exists("sidescroller_focus_x")) {
    var _hx = rig_get_bone_x(rig, "mixamorig:Hips"), _hy = rig_get_bone_y(rig, "mixamorig:Hips");
    if (_hx == 0 && _hy == 0) { _hx = rig_get_x(rig); _hy = rig_get_y(rig) - char_height * 0.5; }
    global.sidescroller_focus_x = _hx;
    global.sidescroller_focus_y = _hy;
}
