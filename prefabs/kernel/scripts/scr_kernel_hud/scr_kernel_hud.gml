/// HUD drawing in GUI space. Deliberately plain: a template overrides
/// the look by drawing its own, and the kernel guarantees only that
/// something legible is on screen from the first frame.

/// @function kernel_gui_width()
function kernel_gui_width() {
    return display_get_gui_width();
}

/// @function kernel_gui_height()
function kernel_gui_height() {
    return display_get_gui_height();
}

/// @function kernel_draw_text(x, y, text, colour, halign)
/// @description Draw one line and restore the alignment afterwards, so
/// a caller never inherits another caller's halign — the single most
/// common cross-component drawing bug.
function kernel_draw_text(x, y, text, colour = c_white, halign = fa_left) {
    // Set every call, like the alignment: leaving the font to whatever drew
    // last is how a title screen ends up in the built-in bitmap face.
    draw_set_font(fnt_kernel);
    draw_set_halign(halign);
    draw_set_valign(fa_top);
    draw_set_colour(colour);
    draw_text(x, y, text);
    draw_set_halign(fa_left);
    draw_set_colour(c_white);
}

/// @function kernel_draw_panel(x, y, w, h, colour, alpha)
/// @description A filled rounded-ish panel; the neutral background the
/// UI pack draws its hotspots on.
function kernel_draw_panel(x, y, w, h, colour = c_black, alpha = 0.55) {
    draw_set_alpha(alpha);
    draw_set_colour(colour);
    draw_rectangle(x, y, x + w, y + h, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

/// @function kernel_draw_hud()
/// @description Score, combo and clock. Drawn by the kernel controller
/// in Draw GUI, so every template has a HUD before it writes one.
function kernel_draw_hud() {
    if (!kernel_playing()) return;
    kernel_draw_text(16, 12, "SCORE " + string(kernel_score()));
    if (kernel_combo() > 1) {
        kernel_draw_text(16, 32, "x" + string(kernel_combo()) + " combo", c_yellow);
    }
    kernel_draw_text(kernel_gui_width() - 16, 12,
        string(floor(kernel_elapsed())) + "s", c_white, fa_right);
}
