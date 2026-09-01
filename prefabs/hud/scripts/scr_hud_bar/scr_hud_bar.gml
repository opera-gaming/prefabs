/// @function hud_bar(x, y, width, height, fraction, fill)
/// @description A filled bar with an outline. `fraction` is clamped, so a
/// caller that overheals cannot draw past the end of the bar.
function hud_bar(x, y, width, height, fraction, fill) {
    var _f = clamp(fraction, 0, 1);
    draw_set_colour(fill);
    draw_rectangle(x, y, x + width * _f, y + height, false);
    draw_set_colour(c_white);
    draw_rectangle(x, y, x + width, y + height, true);
}

/// @function hud_bar_lagged(x, y, width, height, fraction, chase, fill)
/// @description The same bar with a second, slower one behind it showing
/// where the value just was. The lag is what makes a big hit legible —
/// a bar that simply jumps reads as a bar that was always that low.
function hud_bar_lagged(x, y, width, height, fraction, chase, fill) {
    var _f = clamp(fraction, 0, 1);
    var _c = clamp(chase, 0, 1);
    draw_set_colour(c_maroon);
    draw_rectangle(x, y, x + width * max(_f, _c), y + height, false);
    hud_bar(x, y, width, height, _f, fill);
}

/// @function hud_chase(current, target, per_second)
/// @description Move `current` towards `target` at `per_second`, framerate
/// independent. Feed its result back in as the `chase` of a lagged bar.
function hud_chase(current, target, per_second) {
    var _step = per_second * delta_time / 1000000;
    if (current > target) return max(target, current - _step);
    return min(target, current + _step);
}

/// @function hud_pips(x, y, count, filled, size, gap)
/// @description Discrete units — lives, hearts, ammo — as outlined boxes,
/// filled up to `filled`. Better than a bar when the number is small enough
/// to count, because a player can see "two left" without reading a number.
function hud_pips(x, y, count, filled, size, gap) {
    for (var i = 0; i < count; i++) {
        var _x = x + i * (size + gap);
        draw_rectangle(_x, y, _x + size, y + size, i >= filled);
    }
}

