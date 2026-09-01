/// @function snake_cell_centre(board, col, row)
/// @description The middle of a cell. `grid_cell_to_px` gives the top-left
/// corner, and drawing a square body from a corner puts the snake half a
/// cell up and left of the food it is eating.
function snake_cell_centre(board, col, row) {
    var _p = ::grid::grid_cell_to_px(board, col, row);
    return { x: _p.x + board.cell_w / 2, y: _p.y + board.cell_h / 2 };
}

/// @function snake_place_food()
/// @description A free cell for the next food. Rejects cells the body
/// occupies by resampling, which is fine while the board is mostly empty
/// and is the reason a nearly-full board can take a moment.
function snake_place_food() {
    var _tries = 0;
    while (_tries < 400) {
        var _c = irandom(cols - 1);
        var _r = irandom(rows - 1);
        var _clear = true;
        for (var i = 0; i < array_length(body); i++) {
            if (body[i].col == _c && body[i].row == _r) { _clear = false; break; }
        }
        if (_clear) return { col: _c, row: _r };
        _tries += 1;
    }
    return { col: 0, row: 0 };
}

/// @function snake_end()
/// @description Bank the score and show the results. One place, because
/// hitting a wall and biting yourself are the same ending.
function snake_end() {
    ::kernel::kernel_game_over("bitten");
    ::kernel::kernel_save_high_score(::kernel::kernel_score());
    room_goto(rm_results);
}
