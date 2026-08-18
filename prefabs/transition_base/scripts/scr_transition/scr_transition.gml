/// @function goto(room, [time], [params])
/// @description Transition to `room` over `time` seconds using this prefab's
/// fragment shader (sh_transition). `params` overrides the effect's tunable
/// knobs by uniform name — each is a float — e.g. goto(rm_next, 1.0, { speed: 2.0 }).
/// Unspecified knobs fall back to the effect's transition_defaults(); see that
/// script for the knobs a given effect exposes and their default values.
function goto(room, time = 1.0, params = {}) {
    if (!variable_global_exists("active_transition") || global.active_transition == -1) {
        global.active_transition = instance_create_depth(0, 0, 0, obj_transition);
        global.active_transition.target_room = room;
        global.active_transition.fade_length = time;
        global.active_transition.configure(params);
    }
}
