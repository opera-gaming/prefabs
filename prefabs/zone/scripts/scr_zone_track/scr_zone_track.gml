/// @function zone_track(zone, px, py)
/// @description Advance the region by one frame and return what happened:
/// "enter" and "exit" on the single frame each occurs, otherwise "inside" or
/// "outside". Call once per frame per zone, and switch on the result.
function zone_track(zone, px, py) {
    var _now = zone_contains(zone, px, py);
    var _was = zone.inside;
    zone.inside = _now;
    if (_now && !_was) return "enter";
    if (!_now && _was) return "exit";
    return _now ? "inside" : "outside";
}

/// @function zone_entered(zone, px, py)
/// @description `zone_track` reduced to the one question most triggers ask.
/// Still advances the zone, so do not call both in the same frame.
function zone_entered(zone, px, py) {
    return zone_track(zone, px, py) == "enter";
}

/// @function zone_reset(zone)
/// @description Forget whether anything was inside, so the next frame inside
/// counts as an entry again. What a room restart needs — otherwise a player
/// who died inside a trigger never re-triggers it.
function zone_reset(zone) {
    zone.inside = false;
}

