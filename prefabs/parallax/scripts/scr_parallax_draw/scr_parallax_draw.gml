/// @function parallax_step(stack)
/// @description Advance any self-drifting layers. Call once a frame.
function parallax_step(stack) {
    var _dt = delta_time / 1000000;
    for (var i = 0; i < array_length(stack.layers); i++) {
        var _l = stack.layers[i];
        if (!variable_struct_exists(_l, "speed")) continue;
        _l.drift += _l.speed * _dt;
    }
}

/// @function parallax_draw(stack, camera_x, camera_y)
/// @description Draw every layer, tiled to cover the view horizontally.
/// Each is repeated from one screen left to one screen right of the camera,
/// so a layer never runs out however far the camera travels.
///
/// Call from a Draw event. The offsets below are worked out in screen space
/// and then placed back at `camera_x`/`camera_y`, because a Draw event draws
/// in *room* coordinates: without that last step every layer lands near the
/// room origin and a game whose camera has travelled sees nothing at all.
function parallax_draw(stack, camera_x, camera_y) {
    // The view, not the GUI: they are the same only when no view is enabled,
    // and the tiling has to cover what the camera can see.
    var _vw = (view_enabled && view_visible[0])
        ? camera_get_view_width(view_camera[0])
        : display_get_gui_width();
    for (var i = 0; i < array_length(stack.layers); i++) {
        var _l = stack.layers[i];
        if (!sprite_exists(_l.sprite)) continue;
        var _w = sprite_get_width(_l.sprite) * _l.scale;
        if (_w <= 0) continue;

        var _off = camera_x * _l.factor + _l.drift;
        // Modulo *then* step, so the tiling is anchored to the sprite rather
        // than to how far the camera has travelled — the drift that makes a
        // long level slowly desynchronise.
        var _start = -((_off mod _w) + _w) mod _w;
        var _y = _l.y - camera_y * _l.vfactor;
        for (var _x = _start - _w; _x < _vw + _w; _x += _w) {
            draw_sprite_ext(_l.sprite, 0, camera_x + _x, camera_y + _y,
                            _l.scale, _l.scale, 0, c_white, 1);
        }
    }
}


/// @function parallax_layer(layer_name, factor, base_y)
/// @description Parallax a *background layer* — art that lives in the room
/// rather than in a Draw event — by offsetting it against the camera. Call
/// once a frame with the layer's name.
///
/// Worth preferring for the furthest band, because a background layer is
/// room data: the editor draws it, a thumbnail of the room shows it, and a
/// reader of the TOML can see what the sky is. A backdrop drawn in code is
/// invisible to all three, so the room looks nothing like the game.
///
/// Set the layer's `sprite` and `tiled_x = true` in the room file; this only
/// moves it. `factor` is the same 0..1 as `parallax_add` — 0 is painted on,
/// 1 rides with the world.
///
/// `base_y` is where the band sits before the camera moves it, normally
/// `parallax_seat_y(sprite, ground_y)`. It is an argument rather than
/// something you set once because this function owns `layer_y`: anything that
/// sets it separately is overwritten on the next frame, and the band vanishes
/// with nothing to say why.
function parallax_layer(layer_name, factor, base_y = 0) {
    var _id = layer_get_id(layer_name);
    if (!layer_exists(_id)) return false;
    // Against the camera, not accumulated per frame: an offset that adds up
    // drifts out of step the moment anything skips a frame or the camera is
    // moved by hand.
    var _cx = camera_get_view_x(view_camera[0]);
    var _cy = camera_get_view_y(view_camera[0]);
    layer_x(_id, _cx * (1 - factor));
    layer_y(_id, base_y + _cy * (1 - factor));
    return true;
}


/// @function parallax_seat_y(sprite, ground_y)
/// @description The `base_y` that lands the *bottom of the art* on `ground_y`.
/// Work it out once in Create and pass it to `parallax_layer` each frame.
///
/// A background layer draws from its top-left and ignores the sprite's origin,
/// so seating a band on a horizon is arithmetic over where the opaque pixels
/// actually are. Catalog bands are padded, often by a quarter of the canvas,
/// so `ground_y - sprite_get_height()` puts the trees well above the ground.
/// Two bands sized differently then need the sum done twice, and getting it
/// wrong by a few pixels stacks them on each other so the nearer one is never
/// seen.
function parallax_seat_y(sprite, ground_y) {
    if (!sprite_exists(sprite)) return 0;
    // The drawing's bottom edge within the canvas, measured from the top-left
    // — `bbox_bottom` is relative to the origin, so add the origin back.
    var _bottom = sprite_get_bbox_bottom(sprite) + sprite_get_yoffset(sprite);
    return ground_y - _bottom;
}

/// @function parallax_order(layer_names)
/// @description Give the named background layers depths that match their order
/// — first is furthest — and return how many were set.
///
/// Depth and parallax factor have to agree: a band that moves less must also
/// draw further back. Set by hand in two places they drift apart, and the
/// failure is silent and total — the band you meant to be nearer draws behind
/// the far one and is never seen. Pass the same order you pass factors in.
function parallax_order(layer_names) {
    var _n = array_length(layer_names);
    var _set = 0;
    for (var i = 0; i < _n; i++) {
        var _id = layer_get_id(layer_names[i]);
        if (!layer_exists(_id)) continue;
        // Spread so anything placed between two bands still has room.
        layer_depth(_id, 100 * (_n - i) + 100);
        _set += 1;
    }
    return _set;
}
