if (!::kernel::kernel_playing()) exit;
var _dx = keyboard_check(vk_right) - keyboard_check(vk_left);
x = clamp(x + _dx * move_speed, sprite_width / 2, room_width - sprite_width / 2);
