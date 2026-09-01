var _s = 1 + squash * 0.45;
draw_sprite_ext(sprite_index, 0, x, y, _s, 2 - _s,
    point_direction(0, 0, phy_speed_x, phy_speed_y),
    c_white, 1);
