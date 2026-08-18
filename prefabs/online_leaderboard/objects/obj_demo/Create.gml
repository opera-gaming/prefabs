// Demo scene for the online-leaderboard API (scr_online_leaderboard.gml).
// Everything here is presentation only - swap the sprites/fonts for your
// own game's; the gx_* calls are the part this prefab actually provides.

max_entries = 6;
row_width = 760;
row_height = 54;
row_gap = 8;
list_top = 170;

// The API's "avatar" field is a real sprite when running on gx.games, but
// local dev data has no avatar image (it's -1), so this demo hands out a
// placeholder face per row instead whenever there's no real one to draw.
avatar_pool = [
    spr_cartoon_cat_ginger,
    spr_cartoon_dog_corgi,
    spr_cartoon_fox,
    spr_cartoon_owl,
    spr_cartoon_bear_panda,
    spr_cartoon_dog_husky,
    spr_cartoon_cat_black,
    spr_cartoon_dog_labrador,
];

function pick_avatar(sprite_val, fallback_index) {
    if (sprite_val != -1 && sprite_exists(sprite_val)) return sprite_val;
    return avatar_pool[fallback_index mod array_length(avatar_pool)];
}

// Draws `spr` scaled uniformly so it's `size` px wide, centred on (cx, cy) -
// regardless of the sprite's own origin. The placeholder pool is centre-
// origin, but real gx.games avatars (loaded via gx_load_image -> sprite_add)
// are top-left origin, so this can't just draw_sprite_ext() at (cx, cy).
function draw_avatar_centered(spr, cx, cy, size) {
    var w = sprite_get_width(spr);
    var h = sprite_get_height(spr);
    var scale = size / w;
    var xoff = sprite_get_xoffset(spr);
    var yoff = sprite_get_yoffset(spr);
    var draw_x = cx - scale * (w * 0.5 - xoff);
    var draw_y = cy - scale * (h * 0.5 - yoff);
    draw_sprite_ext(spr, 0, draw_x, draw_y, scale, scale, 0, c_white, 1);
}

logged_in = undefined;   // undefined = still checking, then true/false
user_name = "";
user_id = "";
user_avatar = -1;
user_score = -1;
user_score_string = "";
user_country = "";

high_score = [];
best_score = 0;
best_score_country = "";

status_message = "";

function refresh_highscore() {
    gx_get_highscore(function(scores) {
        high_score = scores;
        for (var i = 0; i < array_length(high_score); ++i) {
            high_score[i].score_string = gx_score_to_string(high_score[i].score);
        }
    });
    gx_get_best_score(function(points, cc) {
        best_score = points;
        best_score_country = cc;
    });
}

gx_is_logged_in(function(ok) {
    logged_in = ok;
    if (!ok) return;

    gx_get_profile_info(function(name, avatar, uid) {
        user_name = name;
        user_id = uid;
        user_avatar = avatar;
    });
    gx_get_my_score(function(points, cc) {
        user_score = points;
        user_score_string = gx_score_to_string(points);
        user_country = cc;
    });
});

refresh_highscore();
