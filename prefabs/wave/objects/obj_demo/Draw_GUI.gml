draw_text(40, 30, "wave demo — SPACE resets the curve");
draw_text(40, 70, "wave " + string(wave_number(curve))
    + "   every " + string_format(wave_interval(curve), 1, 2) + "s"
    + "   batch " + string(wave_budget(curve, 2)));

draw_rectangle(40, 100, 40 + 400 * wave_progress(curve), 116, false);
draw_rectangle(40, 100, 440, 116, true);

// Every spawn of the last six seconds, as a tick on a timeline. The ticks
// visibly crowd together as the interval falls.
var _now = current_time;
draw_rectangle(40, 200, 440, 202, false);
for (var i = 0; i < array_length(marks); i++) {
    var _age = (_now - marks[i]) / 1000;
    if (_age > 6) continue;
    var _px = 440 - (_age / 6) * 400;
    draw_rectangle(_px - 1, 186, _px + 1, 216, false);
}
draw_text(40, 240, "spawns, last six seconds");
