::kernel::kernel_draw_text(16, 16, "score " + string(::kernel::kernel_score()));
::kernel::kernel_draw_text(16, 40, "lives " + string(lives_left));
::kernel::kernel_draw_text(16, 64,
    "bricks " + string(instance_number(obj_brick)) + " / " + string(total_bricks));
