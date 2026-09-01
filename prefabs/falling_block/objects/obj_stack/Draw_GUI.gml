var _w = ::kernel::kernel_gui_width();

if (::kernel::kernel_state() == ::kernel::kernel_states().over) {
    ::kernel::kernel_draw_panel(0, 0, _w, ::kernel::kernel_gui_height(), c_black, 0.72);
    ::kernel::kernel_draw_text(_w / 2, 190, "GAME OVER", c_white, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 226, ::kernel::kernel_result(), c_ltgray, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 272,
        "score " + string(::kernel::kernel_score()), c_yellow, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 300,
        string(rows_cleared) + " rows", c_ltgray, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 340,
        "best ever " + string(::kernel::kernel_save_get("high_score", 0)), c_ltgray, fa_center);
    exit;
}

var _o = ::feel::feel_shake_offset();

// Well backing, so the playfield reads as a container and not as loose
// blocks on the background.
::kernel::kernel_draw_panel(board.ox - 4 + _o.x, board.oy - 4 + _o.y,
    board.cols * cell + 8, board.rows * cell + 8, c_black, 0.5);

for (var cy = 0; cy < board.rows; cy++) {
    var _flashing = false;
    for (var i = 0; i < array_length(flash_rows); i++) {
        if (flash_rows[i] == cy) _flashing = true;
    }
    for (var cx = 0; cx < board.cols; cx++) {
        var _v = ::grid::grid_get(board, cx, cy);
        var _p = ::grid::grid_cell_to_px(board, cx, cy);
        var _x = _p.x + _o.x;
        var _y = _p.y + _o.y;

        if (_v == 0) {
            draw_set_alpha(0.10);
            draw_set_colour(c_white);
            draw_rectangle(_x, _y, _x + cell - 1, _y + cell - 1, true);
            draw_set_alpha(1);
            continue;
        }
        var _rgb = pieces[_v - 1].rgb;
        draw_set_colour(_flashing ? c_white : make_colour_rgb(_rgb[0], _rgb[1], _rgb[2]));
        draw_rectangle(_x + 1, _y + 1, _x + cell - 2, _y + cell - 2, false);
    }
}

// The active piece, drawn over the settled board.
if (flash_left <= 0) {
    var _cells = piece_cells(piece, rot, px, py);
    var _rgb = pieces[piece].rgb;
    for (var i = 0; i < array_length(_cells); i++) {
        var _p = ::grid::grid_cell_to_px(board, _cells[i][0], _cells[i][1]);
        draw_set_colour(make_colour_rgb(_rgb[0], _rgb[1], _rgb[2]));
        draw_rectangle(_p.x + 1 + _o.x, _p.y + 1 + _o.y,
                       _p.x + cell - 2 + _o.x, _p.y + cell - 2 + _o.y, false);
    }
}
draw_set_colour(c_white);

::kernel::kernel_draw_text(16, 60, "ROWS " + string(rows_cleared));
::kernel::kernel_draw_text(16, 80, pieces[piece].name);
::kernel::kernel_draw_text(16, ::kernel::kernel_gui_height() - 46, "arrows move");
::kernel::kernel_draw_text(16, ::kernel::kernel_gui_height() - 26, "up rotates, down drops");
