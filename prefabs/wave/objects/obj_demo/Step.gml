if (wave_step(curve)) {
    array_push(marks, current_time);
    if (array_length(marks) > 60) array_delete(marks, 0, 1);
}
if (keyboard_check_pressed(vk_space)) {
    wave_reset(curve);
    marks = [];
}
