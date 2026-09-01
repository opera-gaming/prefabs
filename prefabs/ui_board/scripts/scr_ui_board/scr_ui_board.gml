/// A screenful of interactive objects.
///
/// Everything is in GUI space, because that is where the pointer is
/// reported and where a HUD is drawn — mixing the two spaces is the
/// bug this pack exists to stop each template rediscovering.
///
/// Hover animation runs through ::feel::, and the pointer through
/// ::kernel::, so this pack owns layout and hit-testing and nothing else.

/// @function ui_board_make()
/// @description An empty board.
function ui_board_make() {
    return { spots: [], hot: "", pressed: "", selected: "" };
}

/// @function ui_add(board, id, x, y, w, h, label, payload)
/// @description Add a hotspot. `payload` is whatever the caller wants
/// back when it is clicked — an answer index, an item id, a callback.
function ui_add(board, id, x, y, w, h, label = "", payload = undefined) {
    var _spot = {
        id: id, x: x, y: y, w: w, h: h,
        label: label, payload: payload,
        enabled: true, hover: 0, tint: c_white
    };
    array_push(board.spots, _spot);
    return _spot;
}

/// @function ui_get(board, id)
function ui_get(board, id) {
    for (var i = 0; i < array_length(board.spots); i++) {
        if (board.spots[i].id == id) return board.spots[i];
    }
    return undefined;
}

/// @function ui_clear(board)
function ui_clear(board) {
    board.spots = [];
    board.hot = "";
    board.pressed = "";
    board.selected = "";
}

/// @function ui_set_enabled(board, id, enabled)
function ui_set_enabled(board, id, enabled) {
    var _s = ui_get(board, id);
    if (_s != undefined) _s.enabled = enabled;
}

/// @function ui_set_tint(board, id, colour)
function ui_set_tint(board, id, colour) {
    var _s = ui_get(board, id);
    if (_s != undefined) _s.tint = colour;
}

