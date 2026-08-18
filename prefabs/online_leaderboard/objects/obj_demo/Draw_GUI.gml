var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(fnt_gx_demo_title);
draw_set_color(c_white);
draw_text(gui_w * 0.5, 30, "ONLINE LEADERBOARD");

draw_set_font(fnt_gx_demo_body);

var status;
if (is_undefined(logged_in)) {
    status = "Checking login status...";
} else if (logged_in) {
    status = "Playing as " + user_name + " (" + user_id + ")";
} else {
    status = "Not logged in - log in on gx.games to compete";
}
draw_set_color(c_ltgray);
draw_text(gui_w * 0.5, 84, status);
draw_text(gui_w * 0.5, 110, "Best score ever: " + gx_score_to_string(best_score) + " (" + best_score_country + ")");

// The visible top N, plus (if the logged-in user isn't already in it) one
// extra row at the bottom for their own rank - mirrors gx_get_my_score()
// being a separate call from gx_get_highscore().
var len = min(max_entries, array_length(high_score));
var user_outside_list = (user_score != -1) && (len > 0) && (high_score[len - 1].score > user_score);

var pill_w = sprite_get_width(Flat_Grey_Long_Round);
var pill_h = sprite_get_height(Flat_Grey_Long_Round);
var scale_x = row_width / pill_w;
var scale_y = row_height / pill_h;

var total_rows = len + (user_outside_list ? 1 : 0);
for (var j = 0; j < total_rows; ++j) {
    var px = gui_w * 0.5;
    var py = list_top + j * (row_height + row_gap) + row_height * 0.5;

    var is_user_row = (j == len); // the appended "you" row, if any
    var rank, name, country, score_str, mine, avatar;

    if (is_user_row) {
        rank = -1;
        name = user_name;
        country = user_country;
        score_str = user_score_string;
        mine = true;
        avatar = user_avatar;
    } else {
        var hs = high_score[j];
        rank = j + 1;
        name = hs.user_name;
        country = hs.country_code;
        score_str = hs.score_string;
        mine = (logged_in == true) && (hs.user_id == user_id);
        avatar = hs.avatar;
    }

    var pill = mine ? Flat_Blue_Long_Round : Flat_Grey_Long_Round;
    draw_sprite_ext(pill, 0, px, py, scale_x, scale_y, 0, c_white, 1);

    var avatar_size = row_height * 0.8;
    var avatar_spr = pick_avatar(avatar, j);
    var avatar_x = px - row_width * 0.5 + row_height * 0.5;
    draw_avatar_centered(avatar_spr, avatar_x, py, avatar_size);

    var text_x = px - row_width * 0.5 + row_height + 16;
    var label = (rank == -1 ? "you" : ("#" + string(rank))) + "  " + name + " (" + country + ")";

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(text_x, py, label);

    draw_set_halign(fa_right);
    draw_text(px + row_width * 0.5 - 24, py, score_str);
}

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_text(gui_w * 0.5, gui_h - 40, "Press SPACE to submit a random score");
if (status_message != "") {
    draw_text(gui_w * 0.5, gui_h - 16, status_message);
}
