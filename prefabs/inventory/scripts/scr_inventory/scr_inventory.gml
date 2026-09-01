/// What the player is carrying.
///
/// Slots holding stacks, rather than a flat list, because "twelve arrows"
/// and "twelve separate arrows" are different games — and because the
/// interesting rule is what happens when there is no room for all of it.

/// @function inventory_make(slots, stack_max)
/// @description An empty inventory of `slots` slots, each holding up to
/// `stack_max` of one item. Pass a stack of 1 for a game where every item
/// takes its own slot.
function inventory_make(slots, stack_max) {
    return { slots: max(1, slots), stack: max(1, stack_max), items: [] };
}

/// @function inventory_add(inv, item, count)
/// @description Add up to `count` of `item`, filling part-used stacks before
/// opening new slots. Returns how many actually fit — the difference is what
/// to drop on the floor, and silently discarding it is the bug this return
/// value exists to prevent.
function inventory_add(inv, item, count) {
    var _left = count;
    for (var i = 0; i < array_length(inv.items) && _left > 0; i++) {
        var _s = inv.items[i];
        if (_s.item != item) continue;
        var _room = inv.stack - _s.count;
        var _put = min(_room, _left);
        _s.count += _put;
        _left -= _put;
    }
    while (_left > 0 && array_length(inv.items) < inv.slots) {
        var _put = min(inv.stack, _left);
        array_push(inv.items, { item: item, count: _put });
        _left -= _put;
    }
    return count - _left;
}

/// @function inventory_remove(inv, item, count)
/// @description Take up to `count` away, emptying stacks from the last one
/// back. Returns how many were actually removed.
function inventory_remove(inv, item, count) {
    var _left = count;
    for (var i = array_length(inv.items) - 1; i >= 0 && _left > 0; i--) {
        var _s = inv.items[i];
        if (_s.item != item) continue;
        var _take = min(_s.count, _left);
        _s.count -= _take;
        _left -= _take;
        if (_s.count <= 0) array_delete(inv.items, i, 1);
    }
    return count - _left;
}

/// @function inventory_clear(inv)
function inventory_clear(inv) {
    inv.items = [];
}
