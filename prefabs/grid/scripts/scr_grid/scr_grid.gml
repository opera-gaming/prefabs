/// A board of cells.
///
/// The board is a plain struct holding a flat array, not a ds_grid:
/// structs are garbage-collected and copy cheaply, which is what makes
/// snapshot/restore — and therefore undo — a two-line operation instead
/// of a resource-lifetime problem.

/// @function grid_make(cols, rows, cell_w, cell_h, ox, oy)
/// @description A board of `cols` x `rows` empty cells, drawn from
/// (`ox`, `oy`). Cell value 0 means empty; anything else is the
/// caller's to interpret.
function grid_make(cols, rows, cell_w, cell_h, ox = 0, oy = 0) {
    var _cells = array_create(cols * rows, 0);
    return {
        cols: cols, rows: rows,
        cell_w: cell_w, cell_h: cell_h,
        ox: ox, oy: oy,
        cells: _cells
    };
}

/// @function grid_in_bounds(g, cx, cy)
function grid_in_bounds(g, cx, cy) {
    return (cx >= 0 && cy >= 0 && cx < g.cols && cy < g.rows);
}

/// @function grid_get(g, cx, cy)
/// @description Cell value, or -1 out of bounds. Out-of-bounds reads
/// as solid rather than empty, so a caller testing "can I move here"
/// gets the wall for free.
function grid_get(g, cx, cy) {
    if (!grid_in_bounds(g, cx, cy)) return -1;
    return g.cells[cy * g.cols + cx];
}

/// @function grid_set(g, cx, cy, value)
function grid_set(g, cx, cy, value) {
    if (!grid_in_bounds(g, cx, cy)) return false;
    g.cells[cy * g.cols + cx] = value;
    return true;
}

/// @function grid_empty(g, cx, cy)
function grid_empty(g, cx, cy) {
    return grid_get(g, cx, cy) == 0;
}

/// @function grid_clear(g)
function grid_clear(g) {
    for (var i = 0; i < array_length(g.cells); i++) g.cells[i] = 0;
}

