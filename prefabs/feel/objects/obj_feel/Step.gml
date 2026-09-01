var _dt = delta_time / 1000000;

if (hitstop > 0) hitstop = max(0, hitstop - _dt);
if (shake_left > 0) {
    shake_left = max(0, shake_left - _dt);
    if (shake_left == 0) shake_mag = 0;
}

// Age the popups and drop the finished ones. Rebuilt rather than
// spliced: the list is short and rebuilding cannot skip an entry the
// way removing while iterating does.
var _live = [];
for (var i = 0; i < array_length(pops); i++) {
    var _p = pops[i];
    _p.life += _dt;
    if (_p.life < _p.span) array_push(_live, _p);
}
pops = _live;

// Apply the shake to the camera here, rather than leaving every game to
// remember `feel_shake_offset()`.
//
// It was returned-not-applied so a caller could shake the board or one sprite
// instead — but across nine whole games nobody ever called it, so every
// `feel_shake` in the catalogue was invisible. A view-less room still gets
// nothing (there is no camera to move), and a game that wants to shake
// something else can still ask for the offset and ignore this.
if (view_enabled && view_visible[0]) {
    var _cam = view_camera[0];
    // Undo last frame's offset before applying this one, or the camera walks.
    camera_set_view_pos(_cam,
        camera_get_view_x(_cam) - applied_shake.x,
        camera_get_view_y(_cam) - applied_shake.y);
    applied_shake = feel_shake_offset();
    camera_set_view_pos(_cam,
        camera_get_view_x(_cam) + applied_shake.x,
        camera_get_view_y(_cam) + applied_shake.y);
}
