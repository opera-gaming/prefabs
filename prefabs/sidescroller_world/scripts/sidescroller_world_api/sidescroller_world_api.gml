// The world's API. Anything may call world_focus(); the camera helpers are the
// world's own safe-zone follow, exposed so a custom camera can reuse them.

#macro WORLD_CAM_SAFE_FRAC 0.15   // the focus may wander this far from centre, as a fraction of the view width, before the camera moves
#macro WORLD_CAM_SAFE_UP 170   // how far above centre it may rise before the view lifts
#macro WORLD_CAM_SAFE_DOWN 150 // and how far below before it drops
#macro WORLD_CAM_EASE 0.12

/// Tell the world what to keep in view. Call every step from whatever should be
/// followed (a character does it from its own step); the world reads it in its
/// End Step. Safe to call when no world exists.
function world_focus(_x, _y) {
    global.sidescroller_focus_x = _x;
    global.sidescroller_focus_y = _y;
}

/// The view's left edge, given where the focus is. Returns the new x.
function world_cam_follow_x(_cam_x, _focus_x, _view_w) {
    var _left  = _cam_x + _view_w * (0.5 - WORLD_CAM_SAFE_FRAC);
    var _right = _cam_x + _view_w * (0.5 + WORLD_CAM_SAFE_FRAC);
    var _want  = _cam_x;
    if (_focus_x < _left)  _want = _cam_x + (_focus_x - _left);
    if (_focus_x > _right) _want = _cam_x + (_focus_x - _right);
    _want = clamp(_want, 0, room_width - _view_w);
    return lerp(_cam_x, _want, WORLD_CAM_EASE);
}

/// The view's top edge. A body thrown high pulls the camera up; it settles back
/// down a little more slowly than it lifts, so a bounce does not snap the view.
function world_cam_follow_y(_cam_y, _focus_y, _view_h) {
    var _top = _cam_y + _view_h * 0.5 - WORLD_CAM_SAFE_UP;
    var _bot = _cam_y + _view_h * 0.5 + WORLD_CAM_SAFE_DOWN;
    var _want = _cam_y;
    if (_focus_y < _top) _want = _cam_y + (_focus_y - _top);
    if (_focus_y > _bot) _want = _cam_y + (_focus_y - _bot);
    _want = clamp(_want, 0, room_height - _view_h);
    return lerp(_cam_y, _want, _want > _cam_y ? WORLD_CAM_EASE * 0.6 : WORLD_CAM_EASE);
}
