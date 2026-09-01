// The collector follows the mouse, so the magnet is easy to feel: coins
// start moving before you reach them.
x += (mouse_x - x) * 0.2;
y += (mouse_y - y) * 0.2;

if (keyboard_check_pressed(vk_space)) {
    taken = 0;
    pickup_scatter(obj_demo_coin, 24, 480, 270, 320);
}
