/// @function ui_layout_grid(board, cols, x, y, w, h, gap)
/// @description Re-place every hotspot on a `cols`-wide grid starting at
/// (`x`, `y`). Called after adding, so a caller never computes a
/// position — which is what makes "four answers" and "nine answers" the
/// same code.
function ui_layout_grid(board, cols, x, y, w, h, gap = 12) {
    for (var i = 0; i < array_length(board.spots); i++) {
        var _s = board.spots[i];
        var _col = i % cols;
        var _row = i div cols;
        _s.x = x + _col * (w + gap);
        _s.y = y + _row * (h + gap);
        _s.w = w;
        _s.h = h;
    }
}

/// @function ui_contains(spot, px, py)
function ui_contains(spot, px, py) {
    return (px >= spot.x && py >= spot.y && px <= spot.x + spot.w && py <= spot.y + spot.h);
}

