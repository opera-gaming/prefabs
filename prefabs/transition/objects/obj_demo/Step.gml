transition_step(fade);

// Input is gated on `busy`, so the player stops playing a room they are
// already leaving.
if (transition_busy(fade)) exit;

if (keyboard_check_pressed(vk_space)) {
    transition_go(fade, room == rm_demo ? rm_demo_two : rm_demo);
}
if (keyboard_check_pressed(vk_enter)) style = (style + 1) mod 3;
