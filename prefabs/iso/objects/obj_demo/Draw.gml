for (var row = 0; row < 8; row++) {
    for (var col = 0; col < 8; col++) {
        var _p = iso_to_screen(iso, col, row);
        var _on = (col == hover.col && row == hover.row);
        draw_set_colour(_on ? c_yellow : c_teal);
        // The four corners of the diamond.
        draw_line(_p.x, _p.y - iso.tile_h / 2, _p.x + iso.tile_w / 2, _p.y);
        draw_line(_p.x + iso.tile_w / 2, _p.y, _p.x, _p.y + iso.tile_h / 2);
        draw_line(_p.x, _p.y + iso.tile_h / 2, _p.x - iso.tile_w / 2, _p.y);
        draw_line(_p.x - iso.tile_w / 2, _p.y, _p.x, _p.y - iso.tile_h / 2);
    }
}
draw_set_colour(c_white);
draw_text(24, 24, "iso demo — hover a tile; cell "
    + string(hover.col) + "," + string(hover.row));
