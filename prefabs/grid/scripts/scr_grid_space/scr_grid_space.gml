/// @function grid_cell_to_px(g, cx, cy)
/// @description Top-left pixel of a cell, as {x, y}.
function grid_cell_to_px(g, cx, cy) {
    return { x: g.ox + cx * g.cell_w, y: g.oy + cy * g.cell_h };
}

/// @function grid_px_to_cell(g, px, py)
/// @description Cell under a pixel, as {cx, cy}. May be out of bounds —
/// test with grid_in_bounds rather than trusting it.
function grid_px_to_cell(g, px, py) {
    return {
        cx: floor((px - g.ox) / g.cell_w),
        cy: floor((py - g.oy) / g.cell_h)
    };
}

/// @function grid_neighbours(g, cx, cy, diagonal)
/// @description In-bounds neighbours as an array of {cx, cy}.
function grid_neighbours(g, cx, cy, diagonal = false) {
    var _offsets = diagonal
        ? [[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]]
        : [[0,-1],[-1,0],[1,0],[0,1]];
    var _out = [];
    for (var i = 0; i < array_length(_offsets); i++) {
        var _nx = cx + _offsets[i][0];
        var _ny = cy + _offsets[i][1];
        if (grid_in_bounds(g, _nx, _ny)) array_push(_out, { cx: _nx, cy: _ny });
    }
    return _out;
}

