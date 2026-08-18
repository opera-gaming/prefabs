grid = [
    [{s:asset_get_index("spr_demo_illustrated_side_Flameville"),x:41.0,y:43.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_illustrated_side_Haunted_Graveyard"),x:251.1,y:43.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_illustrated_side_Ice_Land"),x:461.1,y:43.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_illustrated_side_Neon_City"),x:671.0,y:43.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_illustrated_side_Underwater"),x:881.0,y:43.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_illustrated_top_Flameville"),x:1091.0,y:49.7,w:147.9,h:98.5}],
    [{s:asset_get_index("spr_demo_illustrated_top_Haunted_Graveyard"),x:41.0,y:223.7,w:147.9,h:98.5}, {s:asset_get_index("spr_demo_illustrated_top_Ice_Land"),x:251.1,y:223.7,w:147.9,h:98.5}, {s:asset_get_index("spr_demo_illustrated_top_Neon_City"),x:461.1,y:223.7,w:147.9,h:98.5}, {s:asset_get_index("spr_demo_illustrated_top_Underwater"),x:671.0,y:223.7,w:147.9,h:98.5}, {s:asset_get_index("spr_demo_pixel_side_Flameville"),x:881.0,y:217.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_pixel_side_Haunted_Graveyard"),x:1091.0,y:217.5,w:147.9,h:110.9}],
    [{s:asset_get_index("spr_demo_pixel_side_Ice_Land"),x:41.0,y:391.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_pixel_side_Neon_City"),x:251.1,y:391.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_pixel_side_Underwater"),x:461.1,y:391.5,w:147.9,h:110.9}, {s:asset_get_index("spr_demo_pixel_top_Flameville"),x:671.0,y:397.7,w:147.9,h:98.6}],
    [{s:asset_get_index("spr_demo_pixel_top_Haunted_Graveyard"),x:41.0,y:571.7,w:147.9,h:98.6}, {s:asset_get_index("spr_demo_pixel_top_Ice_Land"),x:251.1,y:571.7,w:147.9,h:98.6}, {s:asset_get_index("spr_demo_pixel_top_Neon_City"),x:461.1,y:571.7,w:147.9,h:98.6}, {s:asset_get_index("spr_demo_pixel_top_Underwater"),x:671.0,y:571.7,w:147.9,h:98.6}],
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
panel_x1 = 856.0; panel_y1 = 366.0;
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
