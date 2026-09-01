/// Regions that notice when something enters or leaves them.
///
/// The tracking is the point. Testing "is the player inside" every frame is
/// easy and gives you a door that reopens sixty times a second; what a
/// trigger needs is the single frame the answer *changed*.

/// @function zone_rect(x1, y1, x2, y2)
/// @description A rectangular region, corners in any order.
function zone_rect(x1, y1, x2, y2) {
    return {
        kind: "rect",
        x1: min(x1, x2), y1: min(y1, y2),
        x2: max(x1, x2), y2: max(y1, y2),
        inside: false,
    };
}

/// @function zone_circle(x, y, radius)
/// @description A circular region centred on a point.
function zone_circle(x, y, radius) {
    return { kind: "circle", cx: x, cy: y, r: radius, inside: false };
}

/// @function zone_contains(zone, px, py)
/// @description Whether the point is in the region right now. Stateless —
/// use `zone_track` when you care about the transition.
function zone_contains(zone, px, py) {
    if (zone.kind == "circle") {
        return point_distance(px, py, zone.cx, zone.cy) <= zone.r;
    }
    return px >= zone.x1 && px <= zone.x2 && py >= zone.y1 && py <= zone.y2;
}

/// @function zone_any_inside(zone, obj)
/// @description Whether any instance of `obj` is in the region, and which.
/// Returns the instance or `noone`.
function zone_any_inside(zone, obj) {
    with (obj) {
        if (zone_contains(zone, x, y)) return id;
    }
    return noone;
}

/// @function zone_nearest_edge(zone, px, py)
/// @description Distance from a point to the region — 0 inside it. For a
/// prompt that fades in as the player approaches.
function zone_nearest_edge(zone, px, py) {
    if (zone_contains(zone, px, py)) return 0;
    if (zone.kind == "circle") {
        return point_distance(px, py, zone.cx, zone.cy) - zone.r;
    }
    var _dx = max(zone.x1 - px, 0, px - zone.x2);
    var _dy = max(zone.y1 - py, 0, py - zone.y2);
    return point_distance(0, 0, _dx, _dy);
}

