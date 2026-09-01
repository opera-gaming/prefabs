health_step(guarded);
health_step(raw);

if (keyboard_check(vk_space)) {
    health_hurt(guarded, 1);
    health_hurt(raw, 1);
}
if (keyboard_check_pressed(vk_enter)) {
    health_reset(guarded);
    health_reset(raw);
}
