// The walls are the room's `Tiles` layer; the dots, hero and ghosts are placed
// instances in the same room. Edit either in the room editor — the tile layer
// through `gmx autotile shape rm_play`. This only reads what is there.
//
// Room Start rather than Create: Create runs as each instance is made, so a
// controller placed first in the layer would survey a half-built room.
total_dots = instance_number(obj_dot);

nav = ::pathgrid::pathgrid_make(
    ceil(room_width / cell), ceil(room_height / cell), cell);
// Walls are terrain, so the nav grid is blocked from the tile layer. The
// grid's cell matches the tileset's tile size, which is what lets a cell be
// read as one tile.
::pathgrid::pathgrid_block_tilemap(nav, ::pathgrid::pathgrid_tilemap("Tiles"));
