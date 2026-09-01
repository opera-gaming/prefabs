var _cfg = main_menu_tuning();
items = main_menu_data("items");

board = ::ui_board::ui_board_make();
for (var i = 0; i < array_length(items); i++) {
    ::ui_board::ui_add(board, items[i].id, 0, 0, 0, 0, items[i].label, i);
}
// One column: a vertical list is a grid one wide, so the layout is the
// same call the quiz uses for a 2x2 answer block.
::ui_board::ui_layout_grid(board, 1,
    (::kernel::kernel_gui_width() - _cfg.item_w) / 2, 200,
    _cfg.item_w, _cfg.item_h, _cfg.gap);

selected = 0;
last_mouse = ::kernel::kernel_pointer();

/// Act on a menu id. This is the branch you edit.
// Named `on_choose`, not `choose`: `choose` is a GML built-in, and a bare
// assignment to one does not create an instance variable — reading it back
// gives the function's index rather than what you stored.
on_choose = function(id) {
    ::feel::feel_hitstop(0.05);
    switch (id) {
        case "play": room_goto_next(); break;
        case "how":  show_debug_message("wire up your how-to-play room"); break;
        case "quit": game_end(); break;
    }
};

/// Move the keyboard selection, wrapping at both ends.
move_by = function(dir) {
    var _n = array_length(items);
    selected = (selected + dir + _n) mod _n;
};
