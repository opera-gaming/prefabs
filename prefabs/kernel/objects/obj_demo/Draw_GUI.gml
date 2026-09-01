if (kernel_state() == kernel_states().over) {
    kernel_draw_text(16, 80, "OVER (" + kernel_result() + ") score " + string(kernel_score()));
    kernel_draw_text(16, 100, "best " + string(kernel_save_get("high_score", 0)));
} else {
    kernel_draw_text(16, 80, "kernel demo — click or press space to score");
}
