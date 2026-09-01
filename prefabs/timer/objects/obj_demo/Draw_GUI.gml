draw_text(40, 30, "timer demo — SPACE adds 5s, P pauses, ENTER restarts");

draw_text(40, 80, "round " + timer_format(timer_seconds(bout))
    + (bout.running ? "" : "  (paused)"));
draw_rectangle(40, 104, 40 + 400 * timer_fraction(bout), 120, false);
draw_rectangle(40, 104, 440, 120, true);

draw_text(40, 160, "run    " + timer_format_ms(timer_seconds(run)));
draw_text(40, 200, "expiries counted: " + string(expired));
