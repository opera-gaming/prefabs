if (array_length(grid) == 0) exit;
var _cur = grid[sel_row][sel_col];
var _cx = _cur.x + _cur.w * 0.5;
if (keyboard_check_pressed(vk_left))  sel_col = max(0, sel_col - 1);
if (keyboard_check_pressed(vk_right)) sel_col = min(array_length(grid[sel_row]) - 1, sel_col + 1);
if (keyboard_check_pressed(vk_up) && sel_row > 0) {
    sel_row -= 1;
    sel_col = col_nearest(sel_row, _cx);
}
if (keyboard_check_pressed(vk_down) && sel_row < array_length(grid) - 1) {
    sel_row += 1;
    sel_col = col_nearest(sel_row, _cx);
}
