/// @function pathgrid_find(grid, from_col, from_row, to_col, to_row)
/// @description A* from one cell to another, four-directionally. Returns an
/// array of `{col, row}` starting at the first step and ending at the goal,
/// or an empty array when there is no route — which a caller must handle,
/// because a walled-off target is a normal state, not an error.
function pathgrid_find(grid, from_col, from_row, to_col, to_row) {
    if (!pathgrid_walkable(grid, to_col, to_row)) return [];
    if (from_col == to_col && from_row == to_row) return [];

    var _key = function(_c, _r) { return string(_c) + "," + string(_r); };
    var _open = [{ col: from_col, row: from_row, g: 0,
                   f: abs(from_col - to_col) + abs(from_row - to_row) }];
    var _came = {};
    var _seen = {};
    _seen[$ _key(from_col, from_row)] = 0;

    while (array_length(_open) > 0) {
        // Linear scan for the cheapest. A binary heap would be faster; on a
        // grid this size it is not the part that costs anything.
        var _best = 0;
        for (var i = 1; i < array_length(_open); i++) {
            if (_open[i].f < _open[_best].f) _best = i;
        }
        var _cur = _open[_best];
        array_delete(_open, _best, 1);

        if (_cur.col == to_col && _cur.row == to_row) {
            var _path = [];
            var _at = _key(_cur.col, _cur.row);
            var _node = { col: _cur.col, row: _cur.row };
            while (_at != _key(from_col, from_row)) {
                array_insert(_path, 0, _node);
                _node = _came[$ _at];
                _at = _key(_node.col, _node.row);
            }
            return _path;
        }

        var _steps = [[1, 0], [-1, 0], [0, 1], [0, -1]];
        for (var s = 0; s < 4; s++) {
            var _nc = _cur.col + _steps[s][0];
            var _nr = _cur.row + _steps[s][1];
            if (!pathgrid_walkable(grid, _nc, _nr)) continue;
            var _g = _cur.g + 1;
            var _nk = _key(_nc, _nr);
            if (variable_struct_exists(_seen, _nk) && _seen[$ _nk] <= _g) continue;
            _seen[$ _nk] = _g;
            _came[$ _nk] = { col: _cur.col, row: _cur.row };
            array_push(_open, { col: _nc, row: _nr, g: _g,
                f: _g + abs(_nc - to_col) + abs(_nr - to_row) });
        }
    }
    return [];
}

/// @function pathgrid_next_point(grid, path)
/// @description The room position of the first step of a path, or
/// `undefined` for an empty one. What a mover actually needs each frame.
function pathgrid_next_point(grid, path) {
    if (array_length(path) == 0) return undefined;
    return pathgrid_centre(grid, path[0].col, path[0].row);
}
