/// @function ui_update(board)
/// @description Advance hover animation and hit-test the pointer.
/// Returns the id of the hotspot clicked this frame, or "" — so the
/// caller's Step reads as `var hit = ui_update(board); if (hit != "")`.
function ui_update(board) {
    var _p = ::kernel::kernel_pointer();
    var _dt = delta_time / 1000000;
    var _clicked = "";

    board.hot = "";
    for (var i = 0; i < array_length(board.spots); i++) {
        var _s = board.spots[i];
        var _over = _s.enabled && ui_contains(_s, _p.x, _p.y);
        if (_over) board.hot = _s.id;

        // Hover eases in faster than it eases out; a menu that decays
        // slowly feels responsive, one that snaps back feels twitchy.
        var _target = _over ? 1 : 0;
        var _rate = _over ? 8 : 5;
        _s.hover = _s.hover + (_target - _s.hover) * min(1, _dt * _rate);

        if (_over && ::kernel::kernel_action_pressed("confirm")) {
            _clicked = _s.id;
            board.pressed = _s.id;
            ::feel::feel_hitstop(0.04);
        }
    }
    return _clicked;
}

/// @function ui_draw(board)
/// @description Draw every hotspot. Plain rectangles by design: a
/// template overrides the look by drawing its own sprites over the same
/// rects, and gets working hit-testing either way.
function ui_draw(board) {
    for (var i = 0; i < array_length(board.spots); i++) {
        var _s = board.spots[i];
        var _lift = ::feel::feel_tween(0, 4, _s.hover, "out_quad");
        var _x = _s.x;
        var _y = _s.y - _lift;

        var _fill = _s.enabled ? merge_colour(c_dkgray, _s.tint, 0.25 + 0.35 * _s.hover)
                               : c_dkgray;
        draw_set_alpha(_s.enabled ? 1 : 0.4);
        draw_set_colour(_fill);
        draw_rectangle(_x, _y, _x + _s.w, _y + _s.h, false);
        draw_set_colour(_s.enabled ? _s.tint : c_gray);
        draw_rectangle(_x, _y, _x + _s.w, _y + _s.h, true);

        if (_s.label != "") {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_colour(c_white);
            draw_text_ext(_x + _s.w / 2, _y + _s.h / 2, _s.label, 20, _s.w - 16);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        draw_set_alpha(1);
        draw_set_colour(c_white);
    }
}
