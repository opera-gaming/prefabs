var response = json_parse(json_encode(async_load));

if (response.id == login_request_id) { //gmx-lint-ignore
    login_callback(response.http_status == 200);
} else if (response.id == profile_request_id) {
    if (response.http_status == 200) {
        var data = json_parse(response.result).data;
        user_name = data.username;
        user_id = data.userId;
        gx_load_image(data.avatarUrl, profile_image_loaded, -1, 2.0);
    } else {
        profile_callback("", -1, "");
    }
} else if (response.id == best_score_request_id) {
    if (response.http_status == 200) {
        var data = json_parse(response.result).data;
        if (array_length(data.scores)) {
            best_score_callback(data.scores[0].score, data.scores[0].countryCode);
        } else {
            best_score_callback(0, "SE");
        }
    }
} else if (response.id == score_request_id) {
    scores = [];
    pending_avatars = 0;
    if (response.http_status == 200) {
        var data = json_parse(response.result).data;

        for (var k = 0; k < array_length(data.scores); ++k) {
            var s = data.scores[k];
            if (s.player.avatarUrl != undefined) {
                var img_id = gx_load_image(s.player.avatarUrl, avatar_image_loaded, -1, 2.0);
                pending_avatars++;
                array_push(scores, {
                    "user_name": s.player.username,
                    "user_id": s.player.userId,
                    "avatar": img_id,
                    "country_code": s.countryCode,
                    "score": s.score,
                });
            } else {
                array_push(scores, {
                    "user_name": s.player.username,
                    "user_id": s.player.userId,
                    "avatar": -1,
                    "country_code": s.countryCode,
                    "score": s.score,
                });
            }
        }
    }
    if (pending_avatars == 0) {
        all_scores_callback(scores);
    }
} else if (response.id == user_score_request_id) {
    if (response.http_status == 200) {
        var data = json_parse(response.result).data;
        if (array_length(data.scores)) {
            score_callback(data.scores[0].score, data.scores[0].countryCode);
        } else {
            score_callback(0, "");
        }
    } else {
        score_callback(0, "");
    }
}
