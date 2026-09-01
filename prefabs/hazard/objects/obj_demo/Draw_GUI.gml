draw_text(40, 30, "hazard demo — arrow keys; red hurts, checkpoints move where you return");
draw_text(40, 60, "deaths " + string(hazard_deaths(respawn))
    + "   checkpoint at " + string(respawn.x)
    + (hazard_safe(respawn) ? "   (safe)" : ""));
