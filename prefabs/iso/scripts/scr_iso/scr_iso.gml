/// Isometric projection.
///
/// Two numbers describe a diamond tile: its full width and the height of
/// the diamond ALONE, ignoring any vertical skirt the sprite draws below
/// it. Getting the second one wrong is the classic isometric bug — the
/// grid looks right in isolation and seams open up once tiles neighbour
/// each other — so it is a parameter here rather than a constant.

/// @function iso_make(tile_w, tile_h, ox, oy)
/// @description A projection. `tile_h` is the DIAMOND height, not the
/// sprite height: a 180x125 sprite with a 52px skirt has tile_h = 73.
function iso_make(tile_w, tile_h, ox = 0, oy = 0) {
    return { tile_w: tile_w, tile_h: tile_h, ox: ox, oy: oy };
}

/// @function iso_to_screen(iso, col, row)
/// @description Cell → screen pixel, as {x, y}. Fractional cells are
/// fine, which is what lets something move smoothly between tiles.
function iso_to_screen(iso, col, row) {
    return {
        x: iso.ox + (col - row) * (iso.tile_w / 2),
        y: iso.oy + (col + row) * (iso.tile_h / 2)
    };
}

/// @function iso_to_cell(iso, px, py)
/// @description The inverse, as {col, row}, unrounded. Round both to get
/// the cell under a cursor; keep them fractional to know where in the
/// tile you are.
function iso_to_cell(iso, px, py) {
    var _dx = (px - iso.ox) / (iso.tile_w / 2);
    var _dy = (py - iso.oy) / (iso.tile_h / 2);
    return { col: (_dy + _dx) / 2, row: (_dy - _dx) / 2 };
}

/// @function iso_depth(col, row)
/// @description Sort key for a tile or an actor standing on one. Lower
/// draws in front. Negated because GameMaker treats lower depth as
/// nearer, and tiles further down the screen must occlude those behind.
function iso_depth(col, row) {
    return -(col + row);
}
