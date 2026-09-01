var _f = snake_cell_centre(board, food.col, food.row);
draw_set_colour(c_yellow);
draw_circle(_f.x, _f.y, cell * 0.32, false);

draw_set_colour(c_lime);
for (var i = 0; i < array_length(body); i++) {
    var _p = snake_cell_centre(board, body[i].col, body[i].row);
    var _r = cell * (i == 0 ? 0.46 : 0.38);
    draw_rectangle(_p.x - _r, _p.y - _r, _p.x + _r, _p.y + _r, false);
}
draw_set_colour(c_white);
draw_rectangle(board.ox, board.oy,
    board.ox + cols * cell, board.oy + rows * cell, true);
