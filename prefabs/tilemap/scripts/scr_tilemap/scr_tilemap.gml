/// A level you can read in the source: one string per row, one character
/// per cell.
///
/// The point is that the map stays editable by a person. A level held as
/// placed instances can only be changed in an editor; a level held as
/// twelve strings can be changed in a diff, and you can see the shape of it
/// while you do.

/// @function tilemap_build(rows, cell, legend)
/// @description Place an instance for every character that appears in
/// `legend`, a struct of `{ "#": obj_wall, "o": obj_coin }`. Characters not
/// in the legend are empty space. Returns how many were placed.
///
/// Instances are centred in their cell, so a sprite with a centred origin
/// lines up without an offset.
function tilemap_build(rows, cell, legend) {
    var _made = 0;
    for (var _r = 0; _r < array_length(rows); _r++) {
        var _line = rows[_r];
        for (var _c = 1; _c <= string_length(_line); _c++) {
            var _ch = string_char_at(_line, _c);
            if (!variable_struct_exists(legend, _ch)) continue;
            var _obj = legend[$ _ch];
            if (_obj == noone) continue;
            instance_create_depth(
                (_c - 1) * cell + cell / 2, _r * cell + cell / 2, 0, _obj);
            _made += 1;
        }
    }
    return _made;
}

/// @function tilemap_size(rows, cell)
/// @description The pixel size the map wants, as `{width, height}`. Width
/// comes from the longest row, so a ragged map still covers everything.
function tilemap_size(rows, cell) {
    var _cols = 0;
    for (var i = 0; i < array_length(rows); i++) {
        _cols = max(_cols, string_length(rows[i]));
    }
    return { width: _cols * cell, height: array_length(rows) * cell };
}

/// @function tilemap_count(rows, ch)
/// @description How many cells hold `ch` — the total a "collect them all"
/// objective is counting down from.
function tilemap_count(rows, ch) {
    var _n = 0;
    for (var _r = 0; _r < array_length(rows); _r++) {
        var _line = rows[_r];
        for (var _c = 1; _c <= string_length(_line); _c++) {
            if (string_char_at(_line, _c) == ch) _n += 1;
        }
    }
    return _n;
}
