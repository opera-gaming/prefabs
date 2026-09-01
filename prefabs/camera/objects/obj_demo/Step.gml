var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
var _dy = keyboard_check(vk_down) - keyboard_check(vk_up);
x = clamp(x + _dx * 6, 0, room_width);
y = clamp(y + _dy * 6, 0, room_height);

var _p = camera_follow_step(cam, x, y);
camera_set_view_pos(view_camera[0], _p.x, _p.y);
