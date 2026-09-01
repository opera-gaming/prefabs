/// @function inventory_count(inv, item)
/// @description How many are held across every stack.
function inventory_count(inv, item) {
    var _n = 0;
    for (var i = 0; i < array_length(inv.items); i++) {
        if (inv.items[i].item == item) _n += inv.items[i].count;
    }
    return _n;
}

/// @function inventory_has(inv, item, count)
/// @description Whether at least `count` are held — the check a recipe or a
/// locked door makes before taking them.
function inventory_has(inv, item, count) {
    return inventory_count(inv, item) >= count;
}

/// @function inventory_room_for(inv, item, count)
/// @description How many of `count` would fit right now, without adding any.
/// Ask before showing a pickup prompt.
function inventory_room_for(inv, item, count) {
    var _space = (inv.slots - array_length(inv.items)) * inv.stack;
    for (var i = 0; i < array_length(inv.items); i++) {
        if (inv.items[i].item == item) _space += inv.stack - inv.items[i].count;
    }
    return min(count, _space);
}

/// @function inventory_full(inv)
/// @description Whether every slot is occupied. A full inventory can still
/// take more of something it already holds, so this is not the same as
/// having no room.
function inventory_full(inv) {
    return array_length(inv.items) >= inv.slots;
}

/// @function inventory_slot(inv, index)
/// @description The stack in slot `index` as `{item, count}`, or `undefined`
/// for an empty slot — so a caller can tell an empty slot from a missing one.
function inventory_slot(inv, index) {
    if (index < 0 || index >= array_length(inv.items)) return undefined;
    return inv.items[index];
}

