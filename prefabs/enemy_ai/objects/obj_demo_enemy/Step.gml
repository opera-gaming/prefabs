var _mx = mouse_x;
var _my = mouse_y;

if (ai_sees(ai, _mx, _my)) {
    if (kind == "flee") ai_flee(ai, _mx, _my); else ai_chase(ai, _mx, _my);
    tint = c_red;
} else {
    tint = c_white;
    if (kind == "patrol") ai_patrol(ai); else ai_wander(ai, 1.2);
}
