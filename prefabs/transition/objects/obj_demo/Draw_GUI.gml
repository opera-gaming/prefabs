var _names = ["fade", "wipe", "bars"];
draw_text(40, 30, "transition demo — SPACE changes room, ENTER changes style");
draw_text(40, 50, "style: " + _names[style]);
draw_text(40, 90, room == rm_demo ? "room one" : "room two");
draw_text(40, 110, transition_busy(fade) ? "busy — input is ignored" : "ready");

// Drawn last so it covers this text too.
if (style == 0) transition_draw_fade(fade, c_black);
else if (style == 1) transition_draw_wipe(fade, c_black, true);
else transition_draw_bars(fade, c_black);
