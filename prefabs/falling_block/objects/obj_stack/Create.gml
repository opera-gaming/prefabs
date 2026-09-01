::kernel::kernel_boot();
::kernel::kernel_data_source(falling_block_data, falling_block_tuning());

pieces = ::kernel::kernel_data("pieces");

var _cols = ::kernel::kernel_tuning("cols", 10);
var _rows = ::kernel::kernel_tuning("rows", 18);
cell = ::kernel::kernel_tuning("cell", 26);

// Centre the well; the HUD lives in the margin either side.
var _ox = (::kernel::kernel_gui_width() - _cols * cell) / 2;
board = ::grid::grid_make(_cols, _rows, cell, cell, _ox, 40);

// Cell values are 1-based piece indices so 0 stays "empty" — which is
// what lets grid_empty and grid_row_full work without knowing what a
// piece is.
piece = 0;
rot = [];
px = 0;
py = 0;
fall_timer = 0;
rows_cleared = 0;
flash_rows = [];
flash_left = 0;

/// Cells of the active piece at rotation `r`, offset to (`ax`, `ay`).
piece_cells = function(index, r, ax, ay) {
    var _base = pieces[index].cells;
    var _out = [];
    for (var i = 0; i < array_length(_base); i++) {
        var _cx = _base[i][0];
        var _cy = _base[i][1];
        // Rotate about the 4x4 centre (1.5, 1.5) so every piece turns in
        // place; doing it about the origin walks the piece off the well.
        repeat (r) {
            var _nx = 1.5 + (1.5 - _cy);
            var _ny = 1.5 + (_cx - 1.5);
            _cx = _nx;
            _cy = _ny;
        }
        array_push(_out, [ax + round(_cx), ay + round(_cy)]);
    }
    return _out;
};

/// Would the piece fit at this position and rotation?
fits = function(index, r, ax, ay) {
    var _cells = piece_cells(index, r, ax, ay);
    for (var i = 0; i < array_length(_cells); i++) {
        var _c = _cells[i];
        if (!::grid::grid_in_bounds(board, _c[0], _c[1])) return false;
        if (!::grid::grid_empty(board, _c[0], _c[1])) return false;
    }
    return true;
};

spawn = function() {
    piece = irandom(array_length(pieces) - 1);
    rot = 0;
    px = (board.cols div 2) - 2;
    py = 0;
    // No room for the new piece means the stack reached the top.
    if (!fits(piece, rot, px, py)) ::kernel::kernel_game_over("stack topped out");
};

/// Freeze the piece into the board, score any full rows, spawn the next.
lock_piece = function() {
    var _cells = piece_cells(piece, rot, px, py);
    for (var i = 0; i < array_length(_cells); i++) {
        ::grid::grid_set(board, _cells[i][0], _cells[i][1], piece + 1);
    }
    ::feel::feel_hitstop(0.04);

    var _full = ::grid::grid_full_rows(board);
    if (array_length(_full) > 0) {
        flash_rows = _full;
        flash_left = 0.18;
        rows_cleared += array_length(_full);

        // Clearing several rows at once is worth more than clearing them
        // one at a time — squared, so four is decisively better than four ones.
        var _n = array_length(_full);
        ::kernel::kernel_combo_bump();
        var _gained = ::kernel::kernel_score_add(
            ::kernel::kernel_tuning("points_per_row", 100) * _n * _n);
        ::feel::feel_pop(::kernel::kernel_gui_width() / 2, 200,
            (_n > 1 ? string(_n) + " ROWS  +" : "+") + string(_gained), c_yellow);
        ::feel::feel_shake(0.18 + 0.06 * _n, 4 + 3 * _n);

        // Collapse from the bottom up: removing an upper row first would
        // shift the indices of the ones still to remove.
        for (var i = array_length(_full) - 1; i >= 0; i--) {
            ::grid::grid_collapse_row(board, _full[i]);
        }
    } else {
        ::kernel::kernel_combo_break();
    }
    spawn();
};

/// Gravity gets faster with every row cleared, down to a floor.
fall_interval = function() {
    var _base = ::kernel::kernel_tuning("fall_interval", 0.65);
    var _ramp = ::kernel::kernel_tuning("speed_ramp", 0.04);
    return max(::kernel::kernel_tuning("fall_floor", 0.12), _base - rows_cleared * _ramp);
};

spawn();
::kernel::kernel_state_set(::kernel::kernel_states().play);

// Tuning read once here rather than every frame: one visible block
// of every knob this object answers to, and no struct lookup in Step.
soft_drop = ::kernel::kernel_tuning("soft_drop", 0.04);
