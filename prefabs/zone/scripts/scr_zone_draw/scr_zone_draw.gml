/// @function zone_draw(zone)
/// @description Outline it. Debug only — a trigger you cannot see is a
/// trigger you will misplace.
function zone_draw(zone) {
    if (zone.kind == "circle") {
        draw_circle(zone.cx, zone.cy, zone.r, true);
        return;
    }
    draw_rectangle(zone.x1, zone.y1, zone.x2, zone.y2, true);
}
