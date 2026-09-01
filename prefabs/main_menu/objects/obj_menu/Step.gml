if (::kernel::kernel_action_pressed("up"))   move_by(-1);
if (::kernel::kernel_action_pressed("down")) move_by(1);

// Hover only steals the selection when the mouse actually MOVED this
// frame. Without this gate, arrow-key navigation snaps back to whatever
// item the resting cursor happens to sit over — the single most annoying
// bug in a menu that supports both.
var _p = ::kernel::kernel_pointer();
if (_p.x != last_mouse.x || _p.y != last_mouse.y) {
    for (var i = 0; i < array_length(board.spots); i++) {
        if (::ui_board::ui_contains(board.spots[i], _p.x, _p.y)) selected = i;
    }
}
last_mouse = _p;

var _hit = ::ui_board::ui_update(board);
if (_hit != "") {
    on_choose(_hit);
} else if (::kernel::kernel_action_pressed("confirm")) {
    on_choose(items[selected].id);
}
