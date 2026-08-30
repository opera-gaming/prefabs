// The backdrop and its parallax layers, tiled across the view (they are authored
// to wrap). This instance draws just in front of the room's background colour
// (see Create), so it is behind everything else whatever layer it was placed on.
// A layer with factor f scrolls by f of the camera, so its copies sit at
// vx * (1 - f) + k * w, and it rises by (1 - f) of the camera's climb above its
// starting view; only the copies the view can see are drawn.
var _vx = camera_get_view_x(view_camera[0]);
var _climb = camera_get_view_y(view_camera[0]) - (room_height - view_h);
var _layers = [[bg_far, far_factor], [bg_mid, mid_factor], [bg_sprite, 1]];
for (var i = 0; i < 3; i++) {
    var _spr = _layers[i][0];
    if (_spr == -1) continue;
    var _f = _layers[i][1];
    var _w = sprite_get_width(_spr) * bg_scale;
    var _y = room_height - sprite_get_height(_spr) * bg_scale + _climb * (1 - _f);
    var _bx = _vx * (1 - _f) + floor(_vx * _f / _w) * _w;
    for (; _bx < _vx + view_w; _bx += _w) {
        draw_sprite_ext(_spr, 0, _bx, _y, bg_scale, bg_scale, 0, c_white, 1);
    }
}
