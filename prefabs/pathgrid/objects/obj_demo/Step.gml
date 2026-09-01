var _from = pathgrid_cell_of(nav, 80, 260);
var _to = pathgrid_cell_of(nav, mouse_x, mouse_y);
route = pathgrid_find(nav, _from.col, _from.row, _to.col, _to.row);
