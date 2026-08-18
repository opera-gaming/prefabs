grid = [
    [{s:asset_get_index("spr_camp_fire"),x:29.6,y:22.4,w:118.3,h:118.3}, {s:asset_get_index("spr_candle_flickering"),x:187.1,y:22.4,w:118.3,h:118.3}, {s:asset_get_index("spr_candle_still"),x:344.6,y:22.4,w:118.3,h:118.3}, {s:asset_get_index("spr_circle_swoosh"),x:502.1,y:22.4,w:118.3,h:118.3}, {s:asset_get_index("spr_electric_explosion_with_build_up"),x:659.6,y:22.4,w:118.3,h:118.3}, {s:asset_get_index("spr_electric_explosion_without_build_up"),x:817.1,y:22.4,w:118.3,h:118.3}, {s:asset_get_index("spr_explosion_with_bomb"),x:974.6,y:22.4,w:118.3,h:118.3}, {s:asset_get_index("spr_explosion_without_bomb"),x:1132.1,y:22.4,w:118.3,h:118.3}],
    [{s:asset_get_index("spr_flame_swoosh"),x:29.6,y:161.6,w:118.3,h:118.3}, {s:asset_get_index("spr_incense_smoke"),x:187.1,y:161.6,w:118.3,h:118.3}, {s:asset_get_index("spr_lightning_bolt"),x:369.7,y:161.6,w:68.0,h:118.3}, {s:asset_get_index("spr_lightning_swoosh"),x:502.1,y:161.6,w:118.3,h:118.3}, {s:asset_get_index("spr_magic_sparkle_with_build_up"),x:659.6,y:161.6,w:118.3,h:118.3}, {s:asset_get_index("spr_magic_sparkle_without_build_up"),x:817.1,y:161.6,w:118.3,h:118.3}, {s:asset_get_index("spr_plumes_of_smoke"),x:992.4,y:161.6,w:82.6,h:118.3}, {s:asset_get_index("spr_running_on_land"),x:1132.1,y:172.6,w:118.3,h:96.4}],
    [{s:asset_get_index("spr_running_on_water"),x:29.6,y:311.8,w:118.3,h:96.4}, {s:asset_get_index("spr_shooting_fireball_without_impact"),x:187.1,y:318.9,w:118.3,h:82.2}, {s:asset_get_index("spr_shooting_fireballs_without_impact_version_2"),x:362.6,y:300.8,w:82.2,h:118.3}, {s:asset_get_index("spr_slime_explosion"),x:502.1,y:300.8,w:118.3,h:118.3}, {s:asset_get_index("spr_small_flame"),x:659.6,y:300.8,w:118.3,h:118.3}, {s:asset_get_index("spr_small_puff_of_smoke_front"),x:817.1,y:300.8,w:118.3,h:118.3}, {s:asset_get_index("spr_small_puff_of_smoke_side"),x:974.6,y:311.8,w:118.3,h:96.4}, {s:asset_get_index("spr_small_puff_of_smoke_vertical"),x:1145.4,y:300.8,w:91.7,h:118.3}],
    [{s:asset_get_index("spr_small_spark"),x:29.6,y:440.0,w:118.3,h:118.3}, {s:asset_get_index("spr_smoke_swoosh"),x:187.1,y:440.0,w:118.3,h:118.3}, {s:asset_get_index("spr_spark_of_electricity"),x:344.6,y:440.0,w:118.3,h:118.3}, {s:asset_get_index("spr_star_explosion_with_build_up"),x:502.1,y:440.0,w:118.3,h:118.3}, {s:asset_get_index("spr_star_explosion_without_build_up"),x:659.6,y:440.0,w:118.3,h:118.3}, {s:asset_get_index("spr_water_arc_swoosh"),x:817.1,y:440.0,w:118.3,h:118.3}],
    [{s:asset_get_index("spr_water_droplet"),x:29.6,y:579.2,w:118.3,h:118.3}, {s:asset_get_index("spr_water_splash"),x:187.1,y:579.2,w:118.3,h:118.3}, {s:asset_get_index("spr_water_swoosh"),x:344.6,y:579.2,w:118.3,h:118.3}, {s:asset_get_index("spr_water_tornado"),x:502.1,y:579.2,w:118.3,h:118.3}, {s:asset_get_index("spt_ball_of_electricity"),x:659.6,y:579.2,w:118.3,h:118.3}],
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
panel_x1 = 961.0; panel_y1 = 435.6;
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
