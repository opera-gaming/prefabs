var _dt = delta_time / 1000000;
var _cfg = pause_menu_tuning();
ramp += ((paused ? 1 : 0) - ramp) * min(1, _dt / max(_cfg.fade_seconds, 0.0001));

if (!paused) {
    if (::kernel::kernel_action_pressed("pause")) {
        // Snapshot BEFORE deactivating, or the surface captures an
        // already-empty room.
        if (surface_exists(application_surface)) {
            var _w = surface_get_width(application_surface);
            var _h = surface_get_height(application_surface);
            if (snap != -1 && surface_exists(snap)) surface_free(snap);
            snap = surface_create(_w, _h);
            surface_copy(snap, 0, 0, application_surface);
        }
        instance_deactivate_all(true);
        audio_pause_all();
        paused = true;
        age = 0;
    }
    exit;
}

age += _dt;
if (age > 0.15 && ::kernel::kernel_action_pressed("pause")) {
    instance_activate_all();
    audio_resume_all();
    paused = false;
}
