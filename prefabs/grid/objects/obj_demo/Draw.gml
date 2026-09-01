for (var cy = 0; cy < board.rows; cy++) {
    var _full = grid_row_full(board, cy);
    for (var cx = 0; cx < board.cols; cx++) {
        var _p = grid_cell_to_px(board, cx, cy);
        draw_set_colour(grid_empty(board, cx, cy) ? c_dkgray : (_full ? c_lime : c_aqua));
        draw_rectangle(_p.x + 1, _p.y + 1, _p.x + board.cell_w - 2, _p.y + board.cell_h - 2,
                       grid_empty(board, cx, cy));
    }
}
draw_set_colour(c_white);
draw_text(40, 60, "grid demo — click a cell; a full row turns green; Esc restores");
