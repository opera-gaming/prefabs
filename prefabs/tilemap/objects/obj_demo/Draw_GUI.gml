var _size = tilemap_size(level, cell);
draw_text(40, 250, "tilemap demo — " + string(built) + " blocks placed");
draw_text(40, 270, "map wants " + string(_size.width) + " x " + string(_size.height));
draw_text(40, 290, string(coins) + " coins marked, start at "
    + string(start.x) + "," + string(start.y));
var _c = tilemap_cell_at(cell, mouse_x, mouse_y);
draw_text(40, 320, "mouse cell " + string(_c.col) + "," + string(_c.row)
    + " holds '" + tilemap_at(level, _c.col, _c.row) + "'");
