/// @function pathgrid_tilemap(layer_name)
/// @description The tilemap id of a layer by name, or `noone` if the room has
/// no such layer. Returns something safe in a room that lacks the layer rather
/// than a -1 that fails much later.
function pathgrid_tilemap(layer_name) {
    if (!layer_exists(layer_get_id(layer_name))) return noone;
    var _tm = layer_tilemap_get_id(layer_get_id(layer_name));
    return (_tm == -1) ? noone : _tm;
}

/// @function pathgrid_block_tilemap(grid, tilemap)
/// @description Mark every cell holding a tile as blocked. The counterpart of
/// `pathgrid_block_instances` for terrain that lives in a tile layer rather
/// than as objects — a wall nothing destroys or counts belongs there, and then
/// there are no instances to walk.
///
/// The grid's cell and the layer's tile size are assumed to agree: this reads
/// the tile at each cell's centre, so a grid coarser than the tiles samples
/// between them and misses walls. `noone` is a room with no such layer, and
/// blocks nothing rather than erroring.
function pathgrid_block_tilemap(grid, tilemap) {
    if (tilemap == noone) return;
    var _half = grid.cell / 2;
    for (var _row = 0; _row < grid.rows; _row++) {
        for (var _col = 0; _col < grid.cols; _col++) {
            // Tile index 0 is GameMaker's empty tile, so a non-zero index is
            // terrain. `tilemap_get_at_pixel` wants room coordinates, and
            // returns -1 outside the layer's extent — which is not index 0
            // and would otherwise block every cell the layer does not cover.
            var _t = tilemap_get_at_pixel(tilemap,
                _col * grid.cell + _half, _row * grid.cell + _half);
            if (_t != -1 && tile_get_index(_t) != 0) {
                pathgrid_block(grid, _col, _row, true);
            }
        }
    }
}
