var _w = ::kernel::kernel_gui_width();
::kernel::kernel_draw_text(_w / 2, 190, "RUN OVER", c_white, fa_center);
::kernel::kernel_draw_text(_w / 2, 240,
    "score " + string(::kernel::kernel_score()), c_yellow, fa_center);
::kernel::kernel_draw_text(_w / 2, 270,
    "lasted " + string(floor(::kernel::kernel_elapsed())) + "s", c_ltgray, fa_center);
::kernel::kernel_draw_text(_w / 2, 300,
    "best " + string(::kernel::kernel_save_get("high_score", 0)), c_ltgray, fa_center);
::kernel::kernel_draw_text(_w / 2, 360, "SPACE for the title", c_ltgray, fa_center);
