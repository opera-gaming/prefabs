draw_text(40, 30, "powerup demo — 1 refresh, 2 extend, 3 stack; BACKSPACE clears");
draw_text(40, 50, "press the same key again while it runs to see the rule differ");

var _names = powerup_names(buffs);
for (var i = 0; i < array_length(_names); i++) {
    var _n = _names[i];
    var _y = 110 + i * 46;
    draw_text(40, _y, _n + "  x" + string(powerup_level(buffs, _n))
        + "   " + string_format(powerup_seconds(buffs, _n), 1, 1) + "s");
    draw_rectangle(240, _y, 240 + 300 * powerup_fraction(buffs, _n), _y + 14, false);
    draw_rectangle(240, _y, 540, _y + 14, true);
}

// A multiplier with no branch: level is 0 when the effect is not running.
draw_text(40, 300, "damage multiplier "
    + string_format(1 + powerup_level(buffs, "damage") * 0.5, 1, 1));
for (var i = 0; i < array_length(log_lines); i++) {
    draw_text(640, 110 + i * 20, log_lines[i]);
}
