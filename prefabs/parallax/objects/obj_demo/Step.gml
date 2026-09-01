// A real camera, moved through the view rather than a variable of our own,
// so what the demo shows is what a game would get.
var _cam = view_camera[0];
var _x = camera_get_view_x(_cam)
    + (keyboard_check(vk_right) - keyboard_check(vk_left)) * 6;
camera_set_view_pos(_cam, clamp(_x, 0, room_width - camera_get_view_width(_cam)), 0);

parallax_step(sky);
if (keyboard_check_pressed(vk_space)) {
    camera_set_view_pos(_cam, 1200, 0);
    parallax_reset(sky);
}
