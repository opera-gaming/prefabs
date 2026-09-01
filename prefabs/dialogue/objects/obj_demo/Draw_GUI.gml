draw_text(40, 30, "dialogue demo — SPACE completes then advances, ENTER restarts");
draw_text(40, 60, dialogue_active(chat)
    ? "talking (your own input should be gated on this)"
    : "finished — looping in a moment");
dialogue_draw_box(chat, 60, 340, 840, 130);
