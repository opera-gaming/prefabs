// Arrow-key navigation of the selection over the grid.
if (keyboard_check_pressed(vk_left))  sel_col = max(0, sel_col - 1);
if (keyboard_check_pressed(vk_right)) sel_col = min(array_length(grid[sel_row]) - 1, sel_col + 1);

if (keyboard_check_pressed(vk_up)) {
    sel_row = max(0, sel_row - 1);
    sel_col = min(sel_col, array_length(grid[sel_row]) - 1);
}
if (keyboard_check_pressed(vk_down)) {
    sel_row = min(array_length(grid) - 1, sel_row + 1);
    sel_col = min(sel_col, array_length(grid[sel_row]) - 1);
}
