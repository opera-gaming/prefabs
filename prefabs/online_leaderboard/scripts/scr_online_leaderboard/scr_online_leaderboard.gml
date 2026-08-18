/**
 * Online leaderboard API for gx.games - user login status, profile info,
 * score submission, and leaderboards.
 *
 * Notes:
 * - You must be logged in to: get profile info, submit a score, and get your
 *   own score. Highscores can be viewed without logging in.
 * - Avatars are returned as sprite references (or `-1` when there is none).
 * - When running outside gx.games (e.g. in the editor, or a desktop build)
 *   the game is always considered "logged in" and fed canned test data, so
 *   every function here works offline with no setup.
 */

/**
 * Checks if the user is currently logged in.
 *
 * @param {Function} callback - `(ok: boolean) => void`, called with `true`
 * if the user is logged in, `false` otherwise.
 */
function gx_is_logged_in(callback) {
    gx_get_helper().get_login_status(callback);
}

/**
 * Gets the logged-in user's profile info.
 *
 * @param {Function} callback - `(name: string, avatar: Sprite, user_id: string) => void`,
 * called with the user's display name, avatar sprite (or `-1`), and user ID.
 */
function gx_get_profile_info(callback) {
    gx_get_helper().get_profile_info(callback);
}

/**
 * Submits the logged-in user's score.
 *
 * @param {Real} points - The score to submit.
 */
function gx_submit_score(points) {
    gx_get_helper().submit_score(points);
}

/**
 * Gets the logged-in user's previously submitted best score.
 *
 * @param {Function} callback - `(points: number, country_code: string) => void`,
 * called with the user's score and country code.
 */
function gx_get_my_score(callback) {
    gx_get_helper().get_score(callback);
}

/**
 * Gets the best previously submitted score of all time.
 *
 * @param {Function} callback - `(points: number, country_code: string) => void`,
 * called with the best score and country code.
 */
function gx_get_best_score(callback) {
    gx_get_helper().get_best_score(callback);
}

/**
 * Retrieves the global leaderboard.
 *
 * @param {Function} callback - `(scores: Array<{user_id: string, user_name: string, avatar: Sprite, country_code: string, score: number}>) => void`,
 * called with an array of scores, highest first.
 */
function gx_get_highscore(callback) {
    gx_get_helper().get_highscore(callback);
}

/**
 * Formats a score with thousands separators, e.g. `1840150` -> `"1,840,150"`.
 *
 * @param {Real} score
 * @return {String}
 */
function gx_score_to_string(score) {
    var s = string(abs(score));
    var result = "";
    var len = string_length(s);

    for (var i = 0; i < len; i++) {
        if (i > 0 && (len - i) mod 3 == 0) {
            result += ",";
        }
        result += string_char_at(s, i + 1);
    }

    if (score < 0) {
        result = "-" + result;
    }

    return result;
}

/**
 * Loads an image from a URL into a sprite asynchronously. Used internally to
 * fetch player avatars, but generic enough for any URL-backed image.
 *
 * @param {String} image_url
 * @param {Function} callback - `(http_status: real, sprite: Sprite, request_id: real) => void`,
 * called with the HTTP status, the loaded sprite (or `default_image` on
 * failure/timeout), and this call's request id.
 * @param {Asset.GMSprite} default_image - Sprite to fall back to on failure or timeout.
 * @param {Real} timeout - Seconds to wait before giving up.
 * @return {Id.Instance} The request id, matching the `request_id` passed to `callback`.
 */
function gx_load_image(image_url, callback, default_image, timeout) {
    return instance_create_depth(0, 0, 0, obj_gx_image_loader, { image_url, callback, default_image, timeout });
}

/// @return {Id.Instance} The singleton `obj_gx_highscore_helper` instance, creating it on first use.
function gx_get_helper() {
    static helper = -1;
    if (helper == -1) {
        helper = instance_create_depth(0, 0, 0, obj_gx_highscore_helper);
    }
    return helper;
}
