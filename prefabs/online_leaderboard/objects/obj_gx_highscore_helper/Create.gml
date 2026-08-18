// Singleton controller behind the scr_online_leaderboard.gml API. Created
// on demand by gx_get_helper() - don't place this in a room.

api_base_url = "https://api.gx.games/gg";

// Canned data used whenever the game isn't running on gx.games (the editor,
// a desktop build, `gmx run`, ...), so every API call works offline.
get_dev_user_name = function() { return "local developer"; };
get_dev_avatar = function() { return -1; };
get_dev_user_id = function() { return "USER" };
// Famous video game characters, each tagged with their in-universe (or, where
// that's undefined, their game's country-of-origin) country code.
get_dev_scores = function() {
    return [
        { "user_id" : "1", "user_name": "Mario", "avatar": get_dev_avatar(), "country_code": "IT", "score": 1840150 },
        { "user_id" : "2", "user_name": "Lara Croft", "avatar": get_dev_avatar(), "country_code": "GB", "score": 812006 },
        { "user_id" : "3", "user_name": "Kratos", "avatar": get_dev_avatar(), "country_code": "GR", "score": 624349 },
        { "user_id" : "4", "user_name": "Zagreus", "avatar": get_dev_avatar(), "country_code": "GR", "score": 340000 },
        { "user_id" : "5", "user_name": "Geralt of Rivia", "avatar": get_dev_avatar(), "country_code": "PL", "score": 50373 },
        { "user_id" : "6", "user_name": "Pikachu", "avatar": get_dev_avatar(), "country_code": "JP", "score": 29771 },
        { "user_id" : get_dev_user_id(), "user_name": get_dev_user_name(), "avatar": get_dev_avatar(), "country_code": "SE", "score": 11608 },
    ];
};

header = ds_map_create();
header[? "Content-Type"] = "application/json";
header[? "Access-Control-Allow-Credentials"] = "true";

profile_request_id = -1;
login_request_id = -1;
user_name = undefined;
user_id = undefined;
score_submit_request_id = -1;
user_score_request_id = -1;
score_request_id = -1;
best_score_request_id = -1;
login_callback = undefined;
profile_callback = undefined;
score_callback = undefined;
all_scores_callback = undefined;
best_score_callback = undefined;

scores = [];
pending_avatars = 0;

// Parsed from the page/launch URL's query string on gx.games; absent when
// running anywhere else, which is what flags this as "local dev" below.
query_params = {};
for (var i = 0; i < parameter_count(); ++i) {
    var param = parameter_string(i);
    var eq_pos = string_pos("=", param);
    if (eq_pos > 0) {
        var key = string_copy(param, 1, eq_pos - 1);
        var val = string_copy(param, eq_pos + 1, string_length(param));
        query_params[$ key] = val;
    }
}

local_dev = query_params[$ "source"] == undefined;

game = query_params[$ "modGame"];
if (is_undefined(game)) {
    game = query_params[$ "game"];
}

track = query_params[$ "modTrack"];
if (is_undefined(track)) {
    track = query_params[$ "track"];
}

if (local_dev) {
    scores = get_dev_scores();
}

profile_image_loaded = function(status, img, id) {
    profile_callback(user_name, img, user_id);
}

avatar_image_loaded = function(status, img, id) {
    pending_avatars--;
    for (var k = 0; k < array_length(scores); ++k) {
        if (scores[k].avatar == id) {
            scores[k].avatar = img;
            break;
        }
    }
    if (pending_avatars == 0) {
        all_scores_callback(scores);
    }
}

get_login_status = function(callback) {
    if (local_dev) {
        callback(true);
    } else {
        login_request_id = http_request(api_base_url + "/profile", "GET", header, "");
        login_callback = callback;
    }
}

get_profile_info = function(callback) {
    if (local_dev) {
        var dev_user_name = get_dev_user_name()
        var dev_avatar = get_dev_avatar()
        var dev_user_id = get_dev_user_id()
        callback(dev_user_name, dev_avatar, dev_user_id);
    } else {
        profile_request_id = http_request(api_base_url + "/profile", "GET", header, "");
        profile_callback = callback;
    }
}

submit_score = function(points) {
    if (local_dev) {
        for (var i = 0; i < array_length(scores); ++i) {
            if (scores[i].user_name == get_dev_user_name()) {
                scores[i].score = max(scores[i].score, points);
                break;
            }
        }
        // Mirrors the real backend, which always returns scores sorted
        // highest-first.
        array_sort(scores, function(a, b) { return sign(b.score - a.score); });
    } else {
        points = round(points);
        var _url = api_base_url + "/games/" + game + "/default-challenge/scores";
        var _data = { releaseTrackId: track, score: points };
        score_submit_request_id = http_request(_url, "POST", header, json_stringify(_data));
    }
}

get_score = function(callback) {
    if (local_dev) {
        for (var i = 0; i < array_length(scores); ++i) {
            if (scores[i].user_name == get_dev_user_name()) {
                callback(scores[i].score, scores[i].country_code);
                break;
            }
        }
    } else {
        var _url = api_base_url + "/games/" + game + "/default-challenge/user-scores?trackId=" + track;
        user_score_request_id = http_request(_url, "GET", header, "");
        score_callback = callback;
    }
}

get_best_score = function(callback) {
    if (local_dev) {
        if (array_length(scores)) {
            callback(scores[0].score, scores[0].country_code);
        } else {
            callback(0, "SE");
        }
    } else {
        var _url = api_base_url + "/games/" + game + "/default-challenge/scores?trackId=" + track;
        best_score_request_id = http_request(_url, "GET", header, "");
        best_score_callback = callback;
    }
}

get_highscore = function(callback) {
    if (local_dev) {
        callback(scores);
    } else {
        var _url = api_base_url + "/games/" + game + "/default-challenge/scores?trackId=" + track;
        score_request_id = http_request(_url, "GET", header, "");
        all_scores_callback = callback;
    }
}
