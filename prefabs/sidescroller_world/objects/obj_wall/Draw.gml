var _hw = image_xscale * 0.5, _hh = image_yscale * 0.5;
if (platform_sprite != -1) {
    draw_sprite_stretched(platform_sprite, 0, x - _hw, y - _hh, image_xscale, image_yscale);
} else if (draw) {
    draw_set_colour(colour);
    draw_rectangle(x - _hw, y - _hh, x + _hw, y + _hh, false);
    draw_set_colour(c_white);
}
