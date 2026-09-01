/// @function grid_row_full(g, cy)
function grid_row_full(g, cy) {
    for (var cx = 0; cx < g.cols; cx++) {
        if (grid_empty(g, cx, cy)) return false;
    }
    return true;
}

/// @function grid_full_rows(g)
/// @description Every full row index, top to bottom.
function grid_full_rows(g) {
    var _out = [];
    for (var cy = 0; cy < g.rows; cy++) {
        if (grid_row_full(g, cy)) array_push(_out, cy);
    }
    return _out;
}

/// @function grid_collapse_row(g, cy)
/// @description Delete row `cy` and drop everything above it by one.
function grid_collapse_row(g, cy) {
    for (var _y = cy; _y > 0; _y--) {
        for (var cx = 0; cx < g.cols; cx++) {
            grid_set(g, cx, _y, grid_get(g, cx, _y - 1));
        }
    }
    for (var cx = 0; cx < g.cols; cx++) grid_set(g, cx, 0, 0);
}

