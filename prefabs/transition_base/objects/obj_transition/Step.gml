t += delta_time / 1000000;

if (t > fade_length) {
    surface_free(from_surface);
    surface_free(to_surface);
    instance_destroy();
    global.active_transition = -1;
}
