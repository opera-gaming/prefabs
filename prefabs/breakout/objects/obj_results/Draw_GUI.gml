var _w = ::kernel::kernel_gui_width();
::kernel::kernel_draw_text(_w / 2, 190, ::kernel::kernel_result() == "cleared"
    ? "CLEARED" : "RUN OVER", c_white, fa_center);
::kernel::kernel_draw_text(_w / 2, 250,
    "score " + string(::kernel::kernel_score()), c_yellow, fa_center);
::kernel::kernel_draw_text(_w / 2, 285,
    "best " + string(::kernel::kernel_save_get("high_score", 0)), c_ltgray, fa_center);
::kernel::kernel_draw_text(_w / 2, 350, "SPACE for the title", c_ltgray, fa_center);
