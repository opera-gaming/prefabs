// Standalone demo. ui-board's requirements are not installed here, so
// `gmx validate` warns about the ::kernel:: and ::feel:: calls inside
// the pack — that is the intended "declared but absent" signal.
board = ui_board_make();
for (var i = 0; i < 6; i++) ui_add(board, "spot" + string(i), 0, 0, 0, 0, "Option " + string(i + 1), i);
ui_layout_grid(board, 3, 80, 120, 220, 90);
last = "none";
