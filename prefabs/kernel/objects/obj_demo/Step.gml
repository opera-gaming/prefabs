// Exercise score, combo and the game-over path so `gmx run` on the
// kernel alone shows something moving.
if (kernel_playing() && kernel_action_pressed("confirm")) {
    kernel_combo_bump();
    kernel_score_add(100);
}
if (kernel_playing() && kernel_elapsed() > 20) kernel_game_over("time");
