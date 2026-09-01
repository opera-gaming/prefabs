/// Getting from one cell to another without walking into the wall.
///
/// A* over a grid of blocked cells. The alternative — moving straight at the
/// target and hoping — produces an enemy that presses into a corner forever,
/// which reads as broken rather than as difficult.

/// @function pathgrid_make(cols, rows, cell)
/// @description A grid of `cols` x `rows` cells, each `cell` pixels square,
/// all walkable.
function pathgrid_make(cols, rows, cell) {
    var _blocked = [];
    for (var _r = 0; _r < rows; _r++) {
        var _row = [];
        for (var _c = 0; _c < cols; _c++) array_push(_row, false);
        array_push(_blocked, _row);
    }
    return { cols: cols, rows: rows, cell: cell, blocked: _blocked };
}

/// @function pathgrid_block(grid, col, row, solid)
/// @description Mark one cell blocked or clear.
function pathgrid_block(grid, col, row, solid) {
    if (!pathgrid_inside(grid, col, row)) return;
    grid.blocked[row][col] = solid;
}

/// @function pathgrid_block_instances(grid, obj)
/// @description Mark every cell holding an instance of `obj` as blocked.
/// Rebuild after the world changes — a door that opened is a cell that is
/// still blocked until something says otherwise.
function pathgrid_block_instances(grid, obj) {
    // Held in a local first: inside `with`, `other` is the calling
    // *instance*, and `grid` is an argument rather than one of its
    // variables — so `other.grid` finds nothing and dies at runtime.
    var _g = grid;
    with (obj) {
        pathgrid_block(_g, floor(x / _g.cell), floor(y / _g.cell), true);
    }
}

/// @function pathgrid_inside(grid, col, row)
function pathgrid_inside(grid, col, row) {
    return col >= 0 && row >= 0 && col < grid.cols && row < grid.rows;
}

/// @function pathgrid_walkable(grid, col, row)
function pathgrid_walkable(grid, col, row) {
    if (!pathgrid_inside(grid, col, row)) return false;
    return !grid.blocked[row][col];
}

