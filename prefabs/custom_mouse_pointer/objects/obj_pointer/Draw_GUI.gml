// Draw_GUI is screen space, so the GUI mouse coordinates are the right
// ones. mouse_x/mouse_y are ROOM coordinates and would drift away from
// the pointer as soon as the room has a camera that moves.
var _x = device_mouse_x_to_gui(0);
var _y = device_mouse_y_to_gui(0);

// A plain arrow, so the recipe works with no assets. Swap this whole
// block for draw_sprite_ext once you have a cursor sprite.
draw_set_colour(c_white);
draw_primitive_begin(pr_trianglelist);
draw_vertex(_x, _y);
draw_vertex(_x, _y + size);
draw_vertex(_x + size * 0.62, _y + size * 0.72);
draw_primitive_end();

draw_set_colour(c_black);
draw_line(_x, _y, _x, _y + size);
draw_line(_x, _y, _x + size * 0.62, _y + size * 0.72);
draw_line(_x, _y + size, _x + size * 0.62, _y + size * 0.72);
draw_set_colour(c_white);
