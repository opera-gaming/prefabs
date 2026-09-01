t += 1;

// Pausing for real needs a keypress, which a headless capture has no way to
// make. This drives the same three steps the keypress does, in the same
// order: snapshot first, because `instance_deactivate_all` empties the room
// and a surface copied after it captures nothing.
if (t == 60 && instance_exists(obj_pause)) {
    with (obj_pause) {
        if (surface_exists(application_surface)) {
            var _w = surface_get_width(application_surface);
            var _h = surface_get_height(application_surface);
            if (snap != -1 && surface_exists(snap)) surface_free(snap);
            snap = surface_create(_w, _h);
            surface_copy(snap, 0, 0, application_surface);
        }
        instance_deactivate_all(true);
        paused = true;
        age = 0;
    }
}
