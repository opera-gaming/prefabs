draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_text(16, 12, "SCORE " + string(::kernel::kernel_score()));
draw_text(16, 32, "COMBO " + string(::kernel::kernel_combo())
    + "   BEST " + string(::kernel::kernel_combo_best()));
draw_text(16, 52, "HIT " + string(hits) + "   MISS " + string(misses));

draw_set_halign(fa_right);
draw_text(624, 12, string_format(song_time, 1, 2) + " / " + string_format(song_length, 1, 2) + "s");
draw_set_halign(fa_left);

// The judgement fades rather than latching, so the screen says what just
// happened rather than what happened at some point.
if (song_time - judgement_at < 0.35) {
    draw_set_halign(fa_center);
    draw_text(320, 300, judgement);
    draw_set_halign(fa_left);
}

if (finished) {
    draw_set_halign(fa_center);
    draw_text(320, 200, "SONG COMPLETE");
    draw_text(320, 220, string(hits) + " hit, " + string(misses) + " missed");
    draw_text(320, 240, "SCORE " + string(::kernel::kernel_score()));
    draw_set_halign(fa_left);
} else if (song_time < 1.0) {
    draw_set_halign(fa_center);
    draw_text(320, 200, "ARROW KEYS - hit the note on the line");
    draw_set_halign(fa_left);
}
