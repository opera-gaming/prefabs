if (!::kernel::kernel_playing()) exit;

var _dt = delta_time / 1000000;

// A verdict freezes the board briefly so the player sees which answer
// was right before the next question replaces it.
if (verdict != "") {
    verdict_left -= _dt;
    if (verdict_left <= 0) next_question(index + 1);
    exit;
}

time_left -= _dt;
if (time_left <= 0) {
    answer(-1);
    exit;
}

var _hit = ::ui_board::ui_update(board);
if (_hit != "") {
    var _spot = ::ui_board::ui_get(board, _hit);
    answer(_spot.payload);
}
