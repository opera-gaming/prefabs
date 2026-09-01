draw_text(40, 30, "physics-body demo — SPACE relaunches, P pauses, ENTER pins");
if (!instance_exists(ball)) exit;
draw_text(40, 60, "speed " + string_format(ball.body.cap, 2, 0)
    + " cap, now " + string_format(
        point_distance(0, 0, ball.phy_speed_x, ball.phy_speed_y), 2, 1));
draw_text(40, 80, "bounces " + string(ball.hits));
draw_text(40, 100, paused ? "PAUSED — the body is stopped, not just un-stepped" : "running");
