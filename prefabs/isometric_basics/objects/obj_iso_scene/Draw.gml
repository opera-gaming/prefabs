var _cfg = isometric_basics_tuning();

// Row-major is already back-to-front for an isometric grid, so a sprite
// drawn here needs no sorting. Instances DO — give them
// ::iso::iso_depth(col, row).
for (var row = 0; row < _cfg.rows; row++) {
    for (var col = 0; col < _cfg.cols; col++) {
        var _p = ::iso::iso_to_screen(iso, col, row);
        var _on = (col == hover.col && row == hover.row);
        draw_set_colour(_on ? c_yellow : c_teal);
        var _hw = iso.tile_w / 2;
        var _hh = iso.tile_h / 2;
        draw_line(_p.x, _p.y - _hh, _p.x + _hw, _p.y);
        draw_line(_p.x + _hw, _p.y, _p.x, _p.y + _hh);
        draw_line(_p.x, _p.y + _hh, _p.x - _hw, _p.y);
        draw_line(_p.x - _hw, _p.y, _p.x, _p.y - _hh);
    }
}
draw_set_colour(c_white);
