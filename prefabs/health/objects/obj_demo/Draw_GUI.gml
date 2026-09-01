draw_text(40, 30, "health demo — hold SPACE to take damage, ENTER to reset");

draw_text(40, 80, "with a 0.8s window");
health_draw_bar(40, 100, 300, 24, guarded);
draw_text(360, 100, health_invulnerable(guarded) ? "safe" : "");

draw_text(40, 160, "without one");
health_draw_bar(40, 180, 300, 24, raw);
draw_text(360, 180, health_dead(raw) ? "dead" : "");
