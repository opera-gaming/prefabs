::kernel::kernel_draw_text(16, 16, "distance " + string(runner_distance()));
::kernel::kernel_draw_text(16, 40,
    "speed " + string_format(scroll, 2, 1));
::kernel::kernel_draw_text(16, 64,
    "best " + string(::kernel::kernel_save_get("high_score", 0)));
