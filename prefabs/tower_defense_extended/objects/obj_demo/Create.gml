grid = [
    [{s:asset_get_index("SPR_Cannon_VFX"),x:68.9,y:39.8,w:197.2,h:176.3}, {s:asset_get_index("SPR_Flamer_VFX"),x:439.0,y:29.4,w:87.1,h:197.2}, {s:asset_get_index("SPR_Freeze_VFX"),x:698.9,y:94.0,w:197.2,h:67.9}, {s:asset_get_index("SPR_Heal_VFX"),x:1050.2,y:29.4,w:124.7,h:197.2}],
    [{s:asset_get_index("SPR_Holy_VFX"),x:68.9,y:344.5,w:197.2,h:31.1}, {s:asset_get_index("SPR_Magic_VFX"),x:383.9,y:344.7,w:197.2,h:30.6}, {s:asset_get_index("SPR_Poison_VFX"),x:698.9,y:302.6,w:197.2,h:114.9}],
    [{s:asset_get_index("SPR_Rail_VFX"),x:68.9,y:493.4,w:197.2,h:197.2}, {s:asset_get_index("SPR_Slow_VFX"),x:383.9,y:539.0,w:197.2,h:106.0}],
];
// Drop any cell whose sprite didn't resolve at runtime (e.g. a sprite consumed as
// tileset backing resolves to -1); keeps Draw from dereferencing an invalid sprite.
var _clean = [];
for (var r = 0; r < array_length(grid); r++) {
    var _row = [];
    for (var c = 0; c < array_length(grid[r]); c++) {
        if (sprite_exists(grid[r][c].s)) array_push(_row, grid[r][c]);
    }
    if (array_length(_row) > 0) array_push(_clean, _row);
}
grid = _clean;
sel_row = 0;
sel_col = 0;
panel_x1 = 961.0; panel_y1 = 250.0;
panel_x2 = 1268; panel_y2 = 706;

// Column nearest a target centre-x within a row, for natural up/down movement.
col_nearest = function(_row, _cx) {
    var _best = 0, _bd = 1000000;
    var _n = array_length(grid[_row]);
    for (var c = 0; c < _n; c++) {
        var _d = abs((grid[_row][c].x + grid[_row][c].w * 0.5) - _cx);
        if (_d < _bd) { _bd = _d; _best = c; }
    }
    return _best;
};
