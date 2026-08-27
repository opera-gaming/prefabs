var dt = delta_time / 1000000;
var _down = is_undefined(ragdoll) && !getting_up;   // on its feet and in control

// --- input: tap to walk, tap above to jump -----------------------------------
if (tap_control && _down && mouse_check_button_pressed(mb_left)) {
    var _px = mouse_x, _py = mouse_y;
    var _cx = rig_get_x(rig), _cy = rig_get_y(rig);
    if (_py < _cy - char_height && abs(_px - _cx) < char_height * 0.6) {
        character_jump(id);
    } else if (!jumping && !character_point_on(id, _px, _py)) {
        character_walk_to(id, _px);
    }
}

// --- animation & motion ------------------------------------------------------
if (is_undefined(ragdoll)) {
    rig_update(rig, dt);
    if (getting_up) {
        // Planted until the idle has actually taken over: the queue crossfades
        // it in at the `upright` marker, so there is nothing to do but wait.
        if (rig_get_clip(rig) == clip_idle) {
            getting_up = false;
            phy_active = true;
        }
    } else if (jumping) {
        if (rig_clip_finished(rig)) {
            jumping = false;
            rig_set_position(rig, rig_get_x(rig), ground_y);   // feet back on the line
            rig_set_clip(rig, clip_idle, true, blend_idle);
        }
    } else {
        character_locomotion(id);
    }
    // The capsule rides on the rig. Kinematic, so this is a teleport, not a push.
    phy_position_x = rig_get_x(rig);
    phy_position_y = rig_get_y(rig);
    x = phy_position_x;
    y = phy_position_y;
} else {
    if (character_ragdoll_update(ragdoll) == "done") {
        // The runtime has handed the rig back at the clip's `rise` pose; arm the
        // stop at `upright` and let the clip carry it the rest of the way, with
        // the idle queued to crossfade in off the standing pose.
        ragdoll = undefined;
        rig_play_to_marker(rig, "upright");
        rig_queue_clip(rig, clip_idle, true, blend_idle);
        walk_target = undefined;
        getting_up = true;
    }
    // Where the doll is, so a camera can follow it down.
    x = rig_get_bone_x(rig, "mixamorig:Hips");
    y = rig_get_bone_y(rig, "mixamorig:Hips");
}

// --- camera hand-off -------------------------------------------------------
// The torso's midpoint, walking or ragdolled, so a limb flung out to arm's
// length does not drag the view. Only when a world is listening.
if (variable_global_exists("sidescroller_focus_x")) {
    var _hx = rig_get_bone_x(rig, "mixamorig:Hips"), _hy = rig_get_bone_y(rig, "mixamorig:Hips");
    var _nx = rig_get_bone_x(rig, "mixamorig:Neck"), _ny = rig_get_bone_y(rig, "mixamorig:Neck");
    if (_hx == 0 && _hy == 0) { _hx = rig_get_x(rig); _hy = ground_y - char_height * 0.5; _nx = _hx; _ny = _hy; }
    global.sidescroller_focus_x = (_hx + _nx) * 0.5;
    global.sidescroller_focus_y = (_hy + _ny) * 0.5;
}
