// Three enemies, one of each behaviour, all watching the mouse.
var _kinds = ["wander", "patrol", "flee"];
for (var i = 0; i < 3; i++) {
    var _e = instance_create_depth(200 + i * 260, 400, 0, obj_demo_enemy);
    _e.kind = _kinds[i];
    if (_kinds[i] == "patrol") {
        ai_patrol_set(_e.ai, [[200 + i * 260, 400], [200 + i * 260, 180]]);
    }
}
