// Build a navigable grid from the sprite elements placed on the "Assets" layer.
// Reading the layer at runtime means the grid stays in sync with Assets.toml —
// no duplicated sprite list or grid maths to keep aligned.

var _els = layer_get_all_elements(layer_get_id("Assets"));
var _items = [];
for (var i = 0; i < array_length(_els); i++) {
    var _el = _els[i];
    if (layer_get_element_type(_el) != layerelementtype_sprite) continue;
    array_push(_items, {
        spr: layer_sprite_get_sprite(_el),
        x:   layer_sprite_get_x(_el),
        y:   layer_sprite_get_y(_el),
        w:   sprite_get_width(layer_sprite_get_sprite(_el))  * layer_sprite_get_xscale(_el),
        h:   sprite_get_height(layer_sprite_get_sprite(_el)) * layer_sprite_get_yscale(_el),
    });
}

// Sort into reading order: top-to-bottom, then left-to-right.
array_sort(_items, function(_a, _b) {
    if (abs(_a.y - _b.y) > 8) return _a.y - _b.y; // different rows
    return _a.x - _b.x;                            // same row, by column
});

// Group the sorted items into rows (new row when y jumps by more than half a cell).
grid = [];
var _row = [];
var _prev_y = undefined;
for (var i = 0; i < array_length(_items); i++) {
    var _it = _items[i];
    if (_prev_y != undefined && abs(_it.y - _prev_y) > 20) {
        array_push(grid, _row);
        _row = [];
    }
    array_push(_row, _it);
    _prev_y = _it.y;
}
if (array_length(_row) > 0) array_push(grid, _row);

sel_row = 0;
sel_col = 0;

// Preview panel — sits in the empty lower-right block left open by the grid.
panel_x1 = 1000; panel_y1 = 456;
panel_x2 = 1272; panel_y2 = 712;
