// Tint tracks the keyboard selection so both input paths show the same
// highlight; ui_board owns hover, this owns "selected".
for (var i = 0; i < array_length(board.spots); i++) {
    ::ui_board::ui_set_tint(board, board.spots[i].id, i == selected ? c_aqua : c_white);
}
::ui_board::ui_draw(board);
