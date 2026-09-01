/// The rules of pushing, kept out of the input handling.
///
/// State is a grid of characters rather than instances, because undo has to
/// restore a whole board and copying an array is one line where re-creating
/// instances is a source of bugs.

/// @function soko_load(rows)
/// @description Turn a level's strings into a mutable board. Marks are held
/// separately from crates, so a crate standing on a mark does not erase it —
/// which is the bug that makes a level unwinnable after one push.
function soko_load(rows) {
    var _cells = [];
    var _marks = [];
    var _px = 0;
    var _py = 0;
    for (var _r = 0; _r < array_length(rows); _r++) {
        var _line = rows[_r];
        var _crow = [];
        var _mrow = [];
        for (var _c = 1; _c <= string_length(_line); _c++) {
            var _ch = string_char_at(_line, _c);
            array_push(_mrow, (_ch == "." || _ch == "*"));
            if (_ch == "#") array_push(_crow, "#");
            else if (_ch == "$" || _ch == "*") array_push(_crow, "$");
            else array_push(_crow, " ");
            if (_ch == "@") { _px = _c - 1; _py = _r; }
        }
        array_push(_cells, _crow);
        array_push(_marks, _mrow);
    }
    return { cells: _cells, marks: _marks, px: _px, py: _py, moves: 0 };
}

/// @function soko_at(board, col, row)
/// @description What is in a cell, or "#" outside the board — so every
/// caller can treat off-board as solid without a bounds check.
function soko_at(board, col, row) {
    if (row < 0 || row >= array_length(board.cells)) return "#";
    var _row = board.cells[row];
    if (col < 0 || col >= array_length(_row)) return "#";
    return _row[col];
}

/// @function soko_marked(board, col, row)
function soko_marked(board, col, row) {
    if (row < 0 || row >= array_length(board.marks)) return false;
    var _row = board.marks[row];
    if (col < 0 || col >= array_length(_row)) return false;
    return _row[col];
}

/// @function soko_snapshot(board)
/// @description A copy of everything a move can change. Undo restores this
/// wholesale rather than trying to reverse a push, which is the version that
/// stays correct when a move both walks and pushes.
function soko_snapshot(board) {
    var _copy = [];
    for (var r = 0; r < array_length(board.cells); r++) {
        // Row by row: assigning the array would share it, and the undo
        // would then mutate along with the board it is meant to restore.
        var _row = [];
        for (var c = 0; c < array_length(board.cells[r]); c++) {
            array_push(_row, board.cells[r][c]);
        }
        array_push(_copy, _row);
    }
    return { cells: _copy, px: board.px, py: board.py, moves: board.moves };
}

/// @function soko_restore(board, snap)
function soko_restore(board, snap) {
    board.cells = snap.cells;
    board.px = snap.px;
    board.py = snap.py;
    board.moves = snap.moves;
}

/// @function soko_move(board, dx, dy)
/// @description Walk one cell, pushing a crate if one is in the way and the
/// cell beyond it is free. Returns whether anything moved, so the caller
/// only snapshots and counts a move that actually happened.
///
/// A crate is never pulled. That asymmetry is the entire puzzle.
function soko_move(board, dx, dy) {
    var _nx = board.px + dx;
    var _ny = board.py + dy;
    var _target = soko_at(board, _nx, _ny);

    if (_target == "#") return false;

    if (_target == "$") {
        var _bx = _nx + dx;
        var _by = _ny + dy;
        // A crate cannot be pushed into a wall or into another crate.
        if (soko_at(board, _bx, _by) != " ") return false;
        board.cells[_ny][_nx] = " ";
        board.cells[_by][_bx] = "$";
    }

    board.px = _nx;
    board.py = _ny;
    board.moves += 1;
    return true;
}

/// @function soko_solved(board)
/// @description Whether every mark has a crate on it. Counting marks rather
/// than crates means a level with a spare crate still completes.
function soko_solved(board) {
    for (var r = 0; r < array_length(board.marks); r++) {
        for (var c = 0; c < array_length(board.marks[r]); c++) {
            if (board.marks[r][c] && soko_at(board, c, r) != "$") return false;
        }
    }
    return true;
}
