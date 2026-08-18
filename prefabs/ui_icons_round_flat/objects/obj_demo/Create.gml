grid = [
    [{s:asset_get_index("Icon_ArrowDown"),x:39.5,y:20.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_ArrowLeft"),x:196.9,y:20.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_ArrowRight"),x:354.4,y:20.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_ArrowUp"),x:511.9,y:20.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_AudioOff"),x:669.5,y:20.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_AudioOn"),x:827.0,y:20.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Battle"),x:984.5,y:20.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Bolt"),x:1142.0,y:20.7,w:98.6,h:98.6}],
    [{s:asset_get_index("Icon_Cross"),x:39.5,y:136.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_ExclaimationMark"),x:196.9,y:136.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_FastForward"),x:354.4,y:136.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Heart"),x:511.9,y:136.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Home"),x:669.5,y:136.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Magnify"),x:827.0,y:136.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Menu"),x:984.5,y:136.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Menu2"),x:1142.0,y:136.7,w:98.6,h:98.6}],
    [{s:asset_get_index("Icon_Message"),x:39.5,y:252.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Music"),x:196.9,y:252.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Padlock"),x:354.4,y:252.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_PadlockUnlock"),x:511.9,y:252.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Pause"),x:669.5,y:252.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Play"),x:827.0,y:252.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Plus"),x:984.5,y:252.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Profile"),x:1142.0,y:252.7,w:98.6,h:98.6}],
    [{s:asset_get_index("Icon_QuestionMark"),x:39.5,y:368.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Retry"),x:196.9,y:368.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Rewind"),x:354.4,y:368.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Settings"),x:511.9,y:368.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Share"),x:669.5,y:368.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Shield"),x:827.0,y:368.7,w:98.6,h:98.6}],
    [{s:asset_get_index("Icon_Shop"),x:39.5,y:484.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Star"),x:196.9,y:484.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_ThumbsDown"),x:354.4,y:484.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_ThumbsUp"),x:511.9,y:484.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Tick"),x:669.5,y:484.7,w:98.6,h:98.6}, {s:asset_get_index("Icon_Video"),x:827.0,y:484.7,w:98.6,h:98.6}],
    [{s:asset_get_index("Icon_WiFi"),x:39.5,y:600.7,w:98.6,h:98.6}],
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
panel_x1 = 961.0; panel_y1 = 366.0;
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
