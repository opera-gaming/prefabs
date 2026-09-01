// A real pause: the body is stopped, not merely un-stepped. Skipping your
// own Step leaves the physics world integrating underneath it.
if (keyboard_check_pressed(ord("P"))) {
    paused = !paused;
    with (ball) {
        if (other.paused) phys_freeze(body); else phys_thaw(body);
    }
}
if (keyboard_check_pressed(vk_space) && instance_exists(ball)) {
    with (ball) phys_launch(irandom(359), 12);
}
if (keyboard_check_pressed(vk_enter) && instance_exists(ball)) {
    with (ball) phys_pin(480, 130);
}
