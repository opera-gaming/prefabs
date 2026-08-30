// The doll after this frame's physics, so a hit shows the same frame it lands.
if (!is_undefined(ragdoll)) {
    // It gets up on whatever lies under the hips now, which may not be the floor it was hit on.
    var _hx = rig_get_bone_x(rig, "mixamorig:Hips"), _hy = rig_get_bone_y(rig, "mixamorig:Hips");
    ragdoll.getup = character_ground_below(id, _hx, _hy);
    // The shadow lies at the rig's position: kept under the doll while limp;
    // rising, the runtime owns it (the clip is placed there).
    if (!ragdoll.rising) rig_set_position(rig, _hx, ragdoll.getup);
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
    // Where the doll is, so a camera can follow it down. The capsule follows too:
    // a physics body would otherwise pull x/y back to where it was hit.
    phy_position_x = _hx;
    phy_position_y = _hy;
    x = _hx;
    y = _hy;
}
