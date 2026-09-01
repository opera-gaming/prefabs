if (!::kernel::kernel_playing()) exit;

var _dx = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
var _dy = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);

// One axis per move. Pressing Right and Down on the same frame used to issue
// `soko_move(board, 1, 1)`, which cuts the corner between two walls and can
// push a crate diagonally — a move the rules forbid, and one that either
// "solves" an unsolvable level or wedges a crate where undo cannot reach.
if (_dx != 0 && _dy != 0) _dy = 0;

if (_dx != 0 || _dy != 0) {
    // Snapshot before, keep it only if something actually moved — so a
    // walk into a wall does not fill the undo stack with nothing.
    var _before = soko_snapshot(board);
    if (soko_move(board, _dx, _dy)) {
        array_push(history, _before);
        ::kernel::kernel_score_add(move_score);
    }
}

// Undo restores a whole board rather than reversing a push, which stays
// correct for a move that both walked and pushed.
if (keyboard_check_pressed(ord("Z")) && array_length(history) > 0) {
    soko_restore(board, history[array_length(history) - 1]);
    array_delete(history, array_length(history) - 1, 1);
}
if (keyboard_check_pressed(ord("R"))) {
    board = soko_load(levels[level_at]);
    history = [];
}

if (soko_solved(board)) {
    ::kernel::kernel_score_add(level_score);
    ::feel::feel_shake(0.2, 6);
    level_at += 1;
    if (level_at >= array_length(levels)) {
        ::kernel::kernel_game_over("cleared");
        ::kernel::kernel_save_high_score(::kernel::kernel_score());
        room_goto(rm_results);
        exit;
    }
    board = soko_load(levels[level_at]);
    history = [];
}
