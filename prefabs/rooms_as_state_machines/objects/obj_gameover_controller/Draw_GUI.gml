var _w = ::kernel::kernel_gui_width();
::kernel::kernel_draw_text(_w / 2, 200, "RUN OVER", c_white, fa_center);
::kernel::kernel_draw_text(_w / 2, 244,
    "score " + string(::kernel::kernel_score()), c_yellow, fa_center);
::kernel::kernel_draw_text(_w / 2, 274,
    "best " + string(::kernel::kernel_save_get("high_score", 0)), c_ltgray, fa_center);
::kernel::kernel_draw_text(_w / 2, 320, "SPACE for the title", c_ltgray, fa_center);
