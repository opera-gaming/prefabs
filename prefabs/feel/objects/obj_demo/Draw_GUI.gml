var _o = feel_shake_offset();
draw_text(16 + _o.x, 16 + _o.y, "feel demo — click for hitstop, shake and a popup");
draw_text(16 + _o.x, 36 + _o.y, feel_frozen() ? "FROZEN" : "running");

// Squash a box on the same beat, so the curve is visible and not just felt.
var _s = feel_squash(feel_frozen() ? 0.35 : 0);
draw_rectangle(200 - 40 * _s.xscale, 160 - 40 * _s.yscale,
               200 + 40 * _s.xscale, 160 + 40 * _s.yscale, true);
