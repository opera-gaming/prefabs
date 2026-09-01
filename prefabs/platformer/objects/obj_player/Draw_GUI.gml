::kernel::kernel_draw_text(16, 16, "score " + string(::kernel::kernel_score()));
::kernel::kernel_draw_text(16, 40,
    "coins " + string(global.coins_taken) + "/" + string(global.coins_total));
if (won) ::kernel::kernel_draw_text(16, 72, "you made it — press R to run it again");
