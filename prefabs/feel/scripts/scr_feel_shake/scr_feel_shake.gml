/// @function feel_hitstop(seconds)
/// @description Freeze the world briefly. The single cheapest thing
/// that makes an impact read as an impact.
function feel_hitstop(seconds = 0.08) {
    feel_ensure();
    obj_feel.hitstop = max(obj_feel.hitstop, seconds);
}

/// @function feel_frozen()
/// @description True while hit-stop is running. A caller that moves
/// things checks this; drawing does not.
function feel_frozen() {
    if (!instance_exists(obj_feel)) return false;
    return obj_feel.hitstop > 0;
}

/// @function feel_shake(seconds, magnitude)
function feel_shake(seconds = 0.25, magnitude = 6) {
    feel_ensure();
    obj_feel.shake_time = max(obj_feel.shake_time, seconds);
    obj_feel.shake_left = obj_feel.shake_time;
    obj_feel.shake_mag = max(obj_feel.shake_mag, magnitude);
}

/// @function feel_shake_offset()
/// @description Current shake offset as {x, y}.
///
/// `obj_feel` already applies this to the camera each step, so a game with a
/// view shakes without doing anything. Ask for it directly only to shake
/// something else as well — the board, one sprite — and note that each call
/// returns a fresh random sample.
function feel_shake_offset() {
    if (!instance_exists(obj_feel) || obj_feel.shake_left <= 0) return { x: 0, y: 0 };
    var _f = obj_feel.shake_left / obj_feel.shake_time;
    var _m = obj_feel.shake_mag * _f;
    return { x: random_range(-_m, _m), y: random_range(-_m, _m) };
}

