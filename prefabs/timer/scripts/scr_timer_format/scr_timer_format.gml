/// @function timer_format(seconds)
/// @description `m:ss` — 65 becomes "1:05". Rounds up, so a countdown shows
/// "0:01" for the whole of its last second rather than "0:00" for half of it.
function timer_format(seconds) {
    var _total = ceil(max(0, seconds));
    var _m = _total div 60;
    var _s = _total mod 60;
    return string(_m) + ":" + (_s < 10 ? "0" : "") + string(_s);
}

/// @function timer_format_ms(seconds)
/// @description `m:ss.cc` with hundredths — for a stopwatch, where the
/// difference between two runs is often under a second.
function timer_format_ms(seconds) {
    var _cs = floor(frac(max(0, seconds)) * 100);
    return timer_format(floor(max(0, seconds)))
        + "." + (_cs < 10 ? "0" : "") + string(_cs);
}
