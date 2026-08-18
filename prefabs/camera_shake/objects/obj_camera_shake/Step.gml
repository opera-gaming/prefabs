t += delta_time / 1000000;

if (t > shake_length) {
    instance_destroy();
}
