if (logged_in != true) return;

var points = irandom_range(500, 2_000_000);
gx_submit_score(points);
status_message = "Submitted a score of " + gx_score_to_string(points) + "!";

gx_get_my_score(function(new_points, cc) {
    user_score = new_points;
    user_score_string = gx_score_to_string(new_points);
    user_country = cc;
});
refresh_highscore();
