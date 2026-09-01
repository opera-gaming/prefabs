/// @function tilemap_find(rows, cell, ch)
/// @description Every position holding `ch`, as an array of `{x, y}` in room
/// coordinates. For the things a legend should not spawn — a start point, a
/// camera anchor — which want a position, not an instance.
function tilemap_find(rows, cell, ch) {
    var _hits = [];
    for (var _r = 0; _r < array_length(rows); _r++) {
        var _line = rows[_r];
        for (var _c = 1; _c <= string_length(_line); _c++) {
            if (string_char_at(_line, _c) != ch) continue;
            array_push(_hits, {
                x: (_c - 1) * cell + cell / 2,
                y: _r * cell + cell / 2,
            });
        }
    }
    return _hits;
}

/// @function tilemap_first(rows, cell, ch, fallback_x, fallback_y)
/// @description The first position holding `ch`, or the fallback when the
/// map has none. A start marker someone deleted should not put the player
/// at (0, 0) without saying so.
function tilemap_first(rows, cell, ch, fallback_x, fallback_y) {
    var _hits = tilemap_find(rows, cell, ch);
    if (array_length(_hits) == 0) return { x: fallback_x, y: fallback_y };
    return _hits[0];
}

/// @function tilemap_at(rows, col, row)
/// @description The character at a cell, or " " outside the map — so callers
/// need no bounds check.
function tilemap_at(rows, col, row) {
    if (row < 0 || row >= array_length(rows)) return " ";
    var _line = rows[row];
    if (col < 0 || col >= string_length(_line)) return " ";
    return string_char_at(_line, col + 1);
}

/// @function tilemap_cell_at(cell, px, py)
/// @description Which cell a room position falls in, as `{col, row}`.
function tilemap_cell_at(cell, px, py) {
    return { col: floor(px / cell), row: floor(py / cell) };
}

