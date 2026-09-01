/// The numbers on top of the game.
///
/// Everything here is in GUI space and anchored to a corner, because a HUD
/// positioned in room coordinates scrolls away with the camera the moment
/// the game gets a view — which it always eventually does.

/// @function hud_width()
/// @description GUI width, falling back to the room when no GUI size is set.
function hud_width() {
    var _w = display_get_gui_width();
    return _w > 0 ? _w : room_width;
}

/// @function hud_height()
function hud_height() {
    var _h = display_get_gui_height();
    return _h > 0 ? _h : room_height;
}

/// @function hud_anchor(corner, dx, dy)
/// @description A point `dx`, `dy` in from a named corner — "tl", "tr",
/// "bl", "br", "top", "bottom" or "centre" — as `{x, y}`. Positions written
/// against one corner stay put when the window changes size.
function hud_anchor(corner, dx, dy) {
    var _w = hud_width();
    var _h = hud_height();
    switch (corner) {
        case "tr":     return { x: _w - dx, y: dy };
        case "bl":     return { x: dx, y: _h - dy };
        case "br":     return { x: _w - dx, y: _h - dy };
        case "top":    return { x: _w / 2 + dx, y: dy };
        case "bottom": return { x: _w / 2 + dx, y: _h - dy };
        case "centre": return { x: _w / 2 + dx, y: _h / 2 + dy };
        default:       return { x: dx, y: dy };
    }
}

