if (!::kernel::kernel_playing()) exit;

if (mouse_check_button_pressed(mb_left)) {
    var _c = grid_px_to_cell(board, mouse_x, mouse_y);
    if (grid_in_bounds(board, _c.cx, _c.cy)) {
        grid_set(board, _c.cx, _c.cy, grid_empty(board, _c.cx, _c.cy) ? 1 : 0);
        ::kernel::kernel_score_add(10);
    }
}

// Restart is a snapshot restore — the same mechanism undo would use.
if (::kernel::kernel_action_pressed("cancel")) grid_restore(board, start);
