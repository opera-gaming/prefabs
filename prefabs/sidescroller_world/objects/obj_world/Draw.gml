// The backdrop, tiled across the room's width (it is authored to wrap). This
// instance draws just in front of the room's background colour (see Create),
// so it is behind everything else whatever layer it was placed on. Only the
// tiles the view can see are drawn.
var _x0 = floor(camera_get_view_x(view_camera[0]) / bg_w) * bg_w;
var _x1 = camera_get_view_x(view_camera[0]) + view_w;
for (var _bx = _x0; _bx < _x1; _bx += bg_w) {
    draw_sprite_ext(bg_sprite, 0, _bx, bg_y, bg_scale, bg_scale, 0, c_white, 1);
}
