// `timer_step` is true for exactly one frame, so this counts once per
// expiry rather than once per frame after zero.
if (timer_step(bout)) expired += 1;
timer_step(run);

if (keyboard_check_pressed(vk_space)) timer_add(bout, 5);
if (keyboard_check_pressed(vk_enter)) timer_restart(bout, 30);
if (keyboard_check_pressed(ord("P"))) timer_pause(bout, bout.running);
