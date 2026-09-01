var _ox = (room_width - array_length(board.cells[0]) * cell) / 2;
var _oy = (room_height - array_length(board.cells) * cell) / 2;

for (var r = 0; r < array_length(board.cells); r++) {
    for (var c = 0; c < array_length(board.cells[r]); c++) {
        var _x = _ox + c * cell + cell / 2;
        var _y = _oy + r * cell + cell / 2;

        if (soko_marked(board, c, r)) {
            draw_set_colour(c_olive);
            draw_circle(_x, _y, cell * 0.18, false);
            draw_set_colour(c_white);
        }
        var _what = soko_at(board, c, r);
        if (_what == "#") draw_sprite(spr_block, 0, _x, _y);
        // A crate on its mark is drawn differently, or the player cannot
        // see how close they are without counting.
        else if (_what == "$") {
            draw_sprite_ext(spr_crate, 0, _x, _y, 1, 1, 0,
                soko_marked(board, c, r) ? c_lime : c_white, 1);
        }
    }
}
draw_sprite(spr_pusher, 0,
    _ox + board.px * cell + cell / 2, _oy + board.py * cell + cell / 2);
