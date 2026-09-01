/// A view that follows something.
///
/// Three rules, applied in this order and no other: the deadzone decides
/// whether the camera wants to move at all, the ease decides how fast it
/// gets there, and the clamp decides where it is allowed to end up. Ease
/// after clamp lets the view drift outside the room and snap back; clamp
/// after ease is what makes the edges feel solid.

/// @function camera_follow_make(view_w, view_h, tuning)
/// @description Camera state for a `view_w` x `view_h` view. Override any
/// default by passing a struct.
function camera_follow_make(view_w, view_h, tuning = {}) {
    var _d = {
        view_w: view_w,
        view_h: view_h,
        // Half-size of the box the target moves in before the camera
        // reacts. Zero follows every pixel, which reads as motion
        // sickness on a walking character.
        deadzone_x: view_w * 0.15,
        deadzone_y: view_h * 0.15,
        // 1 snaps, 0 never arrives. 0.1–0.2 is a camera you stop noticing.
        ease: 0.15,
        x: 0,
        y: 0
    };
    var _keys = variable_struct_get_names(tuning);
    for (var i = 0; i < array_length(_keys); i++) {
        _d[$ _keys[i]] = tuning[$ _keys[i]];
    }
    return _d;
}

/// @function camera_follow_step(state, tx, ty)
/// @description Move `state` one frame toward (`tx`, `ty`) and return the
/// top-left corner as a struct `{x, y}`. Apply it with
/// `camera_set_view_pos(view_camera[0], p.x, p.y)`.
function camera_follow_step(state, tx, ty) {
    var _cx = state.x + state.view_w * 0.5;
    var _cy = state.y + state.view_h * 0.5;

    // Only the distance *beyond* the deadzone is a reason to move.
    var _dx = tx - _cx;
    var _dy = ty - _cy;
    if (abs(_dx) <= state.deadzone_x) _dx = 0;
    else _dx -= sign(_dx) * state.deadzone_x;
    if (abs(_dy) <= state.deadzone_y) _dy = 0;
    else _dy -= sign(_dy) * state.deadzone_y;

    state.x += _dx * state.ease;
    state.y += _dy * state.ease;

    // Clamp last, so a room edge is a hard stop rather than something the
    // ease keeps pulling away from. A room smaller than the view pins to 0
    // instead of producing a negative range.
    state.x = clamp(state.x, 0, max(0, room_width - state.view_w));
    state.y = clamp(state.y, 0, max(0, room_height - state.view_h));

    return { x: state.x, y: state.y };
}

/// @function camera_follow_snap(state, tx, ty)
/// @description Put the camera where it would eventually settle, with no
/// ease. Use it on room start so the first frame is not a pan in from the
/// corner.
function camera_follow_snap(state, tx, ty) {
    state.x = clamp(tx - state.view_w * 0.5, 0, max(0, room_width - state.view_w));
    state.y = clamp(ty - state.view_h * 0.5, 0, max(0, room_height - state.view_h));
    return { x: state.x, y: state.y };
}
