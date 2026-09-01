t += delta_time / 1000000;

if (::kernel::kernel_action_pressed("confirm")) {
    ::feel::feel_hitstop(0.05);
    room_goto_next();
}
