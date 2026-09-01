/// Depth from layers that move at different speeds.
///
/// Two rules make it read as depth rather than as sliding wallpaper:
/// further layers move less, and every layer wraps rather than ending. A
/// layer that runs out is the one thing that destroys the effect outright.
///
/// A band that can live in the room should: name it on a background layer and
/// move it with `parallax_layer`, so the room file says what the backdrop is.
/// The stack below draws in code and is the fallback for what cannot - a
/// foreground at `factor > 1`, self-drifting clouds, more bands than layers.

/// @function parallax_make()
/// @description An empty stack of layers. Add to it back-to-front.
function parallax_make() {
    return { layers: [] };
}

/// @function parallax_add(stack, sprite, factor, y, vertical_factor, scale)
/// @description Add a layer drawn at `y` that moves at `factor` of the
/// camera — 0 is painted on, 1 moves with the world. Anything above 1 sits
/// in front of the action, which is what a foreground layer wants. `scale`
/// sizes art that was not drawn for this view; the tiling follows it, so a
/// scaled layer still meets itself edge to edge.
///
/// `vertical_factor` defaults to 0 — a band that does not move with the
/// camera's height, which is nearly every backdrop. Leaving it required cost
/// a caller a `FATAL ERROR: undefined value` raised inside `parallax_draw`
/// with no line number, for the omission of the argument they least needed.
function parallax_add(stack, sprite, factor, y, vertical_factor = 0, scale = 1) {
    array_push(stack.layers, {
        sprite: sprite,
        factor: factor,
        vfactor: vertical_factor,
        y: y,
        scale: scale,
        drift: 0,
    });
    return array_length(stack.layers) - 1;
}

/// @function parallax_fit(stack, index, view_height)
/// @description Scale a layer to stand `view_height` tall. Catalog backdrops
/// are drawn far larger than a view, and a layer that overflows it is the
/// same mistake as one that runs out.
function parallax_fit(stack, index, view_height) {
    if (index < 0 || index >= array_length(stack.layers)) return;
    var _l = stack.layers[index];
    var _h = sprite_get_height(_l.sprite);
    if (_h > 0) _l.scale = view_height / _h;
}

/// @function parallax_drift(stack, index, pixels_per_second)
/// @description Make a layer scroll on its own as well — clouds that move
/// while the player stands still. Added to the camera-driven offset.
function parallax_drift(stack, index, pixels_per_second) {
    if (index < 0 || index >= array_length(stack.layers)) return;
    stack.layers[index].speed = pixels_per_second;
}

/// @function parallax_reset(stack)
/// @description Clear accumulated drift. A new run should not start with
/// the clouds wherever the last one left them.
function parallax_reset(stack) {
    for (var i = 0; i < array_length(stack.layers); i++) {
        stack.layers[i].drift = 0;
    }
}
