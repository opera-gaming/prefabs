/// @function pathgrid_cell_of(grid, px, py)
/// @description Which cell a room position is in, as `{col, row}`.
function pathgrid_cell_of(grid, px, py) {
    return { col: floor(px / grid.cell), row: floor(py / grid.cell) };
}

/// @function pathgrid_centre(grid, col, row)
/// @description The room position at the middle of a cell, as `{x, y}` —
/// where a mover should aim so it does not clip the corner of a wall.
function pathgrid_centre(grid, col, row) {
    return { x: col * grid.cell + grid.cell / 2, y: row * grid.cell + grid.cell / 2 };
}

