if (!::kernel::kernel_playing()) exit;

// Placeholder for your game. Replace everything below.
if (::kernel::kernel_action_pressed("confirm")) {
    ::kernel::kernel_score_add(100);
}
if (::kernel::kernel_elapsed() > 10) {
    ::kernel::kernel_game_over("time");
    room_goto(rm_gameover);
}
