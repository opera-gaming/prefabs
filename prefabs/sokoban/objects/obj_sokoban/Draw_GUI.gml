::kernel::kernel_draw_text(16, 16,
    "level " + string(level_at + 1) + " of " + string(array_length(levels)));
::kernel::kernel_draw_text(16, 40, "moves " + string(board.moves));
::kernel::kernel_draw_text(16, 64, "score " + string(::kernel::kernel_score()));
::kernel::kernel_draw_text(16, 96, "Z undo    R restart");
