var _w = ::kernel::kernel_gui_width();
var _s = ::kernel::kernel_state();

if (_s == ::kernel::kernel_states().over) {
    ::kernel::kernel_draw_panel(0, 0, _w, ::kernel::kernel_gui_height(), c_black, 0.7);
    ::kernel::kernel_draw_text(_w / 2, 180, "RUN OVER", c_white, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 220, ::kernel::kernel_result(), c_ltgray, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 270,
        "score " + string(::kernel::kernel_score()), c_yellow, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 300,
        "best streak x" + string(::kernel::kernel_combo_best()), c_ltgray, fa_center);
    ::kernel::kernel_draw_text(_w / 2, 340,
        "best ever " + string(::kernel::kernel_save_get("high_score", 0)), c_ltgray, fa_center);
    exit;
}

if (!::kernel::kernel_playing()) exit;

var _q = questions[index];

// Question card.
::kernel::kernel_draw_panel(120, 120, _w - 240, 100, c_black, 0.45);
::kernel::kernel_draw_text(_w / 2, 152, _q.ask, c_white, fa_center);
::kernel::kernel_draw_text(_w / 2, 190,
    "question " + string(index + 1) + " of " + string(array_length(questions)),
    c_gray, fa_center);

::ui_board::ui_draw(board);

// Timer bar: the clock is the pressure, so it gets a bar and not a number.
var _frac = clamp(time_left / question_time, 0, 1);
::kernel::kernel_draw_panel(120, 108, _w - 240, 6, c_black, 0.5);
draw_set_colour(_frac < 0.25 ? c_red : c_aqua);
draw_rectangle(120, 108, 120 + (_w - 240) * _frac, 114, false);
draw_set_colour(c_white);

::kernel::kernel_draw_text(_w - 16, 32, "lives " + string(lives_left), c_white, fa_right);
