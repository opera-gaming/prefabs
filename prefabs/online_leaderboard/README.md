# online-leaderboard

**Live demo:** https://gx.games/games/k1ptur/online-leaderboard-demo/tracks/1a12b6e1-bc15-46c1-bc2a-4c237eda75be/

gx.games leaderboard API: login status, profile info, score
submission, and highscore lists. 

Everything in `scripts/scr_online_leaderboard/` and the two internal
controller objects works with **no UI or art dependencies** - outside
gx.games (the editor, a desktop build, `gmx run`) it transparently falls
back to canned local-dev data, so you can build and test against it
offline, with no setup.

## Usage

All API calls are asynchronous: pass a callback, get the result later.

### `gx_is_logged_in(callback)`

Checks if the user is currently logged in.

- `callback(ok)` - `ok: bool`, `true` if the user is logged in.

Highscores (`gx_get_highscore`, `gx_get_best_score`) can be read without
being logged in; everything else requires it.

```gml
gx_is_logged_in(function(ok) {
    if (ok) show_debug_message("logged in");
});
```

### `gx_get_profile_info(callback)`

Gets the logged-in user's profile.

- `callback(name, avatar, user_id)`
  - `name: string` - display name.
  - `avatar: Sprite` - avatar image, or `-1` if there is none.
  - `user_id: string`

```gml
gx_get_profile_info(function(name, avatar, user_id) {
    user_name = name;
});
```

### `gx_submit_score(points)`

Submits the logged-in user's score.

- `points: real`

No callback - fire and forget. Call `gx_get_my_score` or
`gx_get_highscore` afterwards to see the effect (in local dev the update is
immediate; on gx.games allow a moment for the server round-trip).

```gml
gx_submit_score(current_score);
```

### `gx_get_my_score(callback)`

Gets the logged-in user's previously submitted best score.

- `callback(points, country_code)`
  - `points: real`
  - `country_code: string`

```gml
gx_get_my_score(function(points, cc) {
    my_best = points;
});
```

### `gx_get_best_score(callback)`

Gets the best score submitted by anyone, ever.

- `callback(points, country_code)` - same shape as `gx_get_my_score`.

```gml
gx_get_best_score(function(points, cc) {
    world_best = points;
});
```

### `gx_get_highscore(callback)`

Retrieves the global leaderboard, highest score first.

- `callback(scores)` - `scores: Array<{ user_id, user_name, avatar, country_code, score }>`
  - `user_id: string`
  - `user_name: string`
  - `avatar: Sprite` - or `-1` if there is none.
  - `country_code: string`
  - `score: real`

```gml
gx_get_highscore(function(scores) {
    for (var i = 0; i < array_length(scores); ++i) {
        show_debug_message(scores[i].user_name + ": " + string(scores[i].score));
    }
});
```

### `gx_score_to_string(score)`

Formats a score with thousands separators for display.

- `score: real`
- returns `string`, e.g. `gx_score_to_string(1840150)` -> `"1,840,150"`.

### `gx_load_image(image_url, callback, default_image, timeout)`

Loads an image from a URL into a sprite asynchronously. Used internally by
`gx_get_profile_info` / `gx_get_highscore` to fetch avatars, but generic
enough for any URL-backed image.

- `image_url: string`
- `callback(http_status, sprite, request_id)`
  - `http_status: real`
  - `sprite: Sprite` - the loaded image, or `default_image` on failure/timeout.
  - `request_id` - matches this call's return value.
- `default_image: Sprite` - fallback sprite for failure or timeout.
- `timeout: real` - seconds to wait before giving up.
- returns the request id (an instance id), also passed to `callback`.

## Local development vs. gx.games

On gx.games, the API talks to the real backend over HTTP. Anywhere else
(the GameMaker/gmx editor, a desktop build, `gmx run`, a `gmx gametest`) it
falls back to fake, hardcoded data - there's no real backend to talk to
until the game is actually published and running embedded on gx.games.

The detection lives in `objects/obj_gx_highscore_helper/Create.gml`: gx.games
embeds a game with launch query params (`source=`, `game=`, `track=`, ...),
read here via `parameter_string()`. Their absence is what flags a run as
"local dev":

```gml
local_dev = query_params[$ "source"] == undefined;
```

## Demo

`rooms/rm_demo` + `objects/obj_demo` draw a sample leaderboard screen
exercising the whole API - login status, profile, my score, best score,
highscore list, and submit-then-refresh on <kbd>Space</kbd> - using sprites
vendored from the `iconic-animals` and `ui-panels-flat` catalog prefabs.
Demo-only, excluded from the published prefab.
