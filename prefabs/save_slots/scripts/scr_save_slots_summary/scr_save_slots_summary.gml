/// @function save_slots_summary(slot, keys)
/// @description The named fields of a slot as a struct, for a slot-select
/// screen that wants a level and a play time without loading the whole save.
/// Missing keys come back as `undefined`.
function save_slots_summary(slot, keys) {
    var _data = save_slots_read(slot, undefined);
    var _out = { used: _data != undefined };
    if (_data == undefined) return _out;
    for (var i = 0; i < array_length(keys); i++) {
        var _k = keys[i];
        _out[$ _k] = variable_struct_exists(_data, _k) ? _data[$ _k] : undefined;
    }
    return _out;
}

/// @function save_slots_used(count)
/// @description Which of slots 0..count-1 hold a save, as an array of bools.
function save_slots_used(count) {
    var _out = [];
    for (var i = 0; i < count; i++) array_push(_out, save_slots_exists(i));
    return _out;
}

/// @function save_slots_copy(from_slot, to_slot)
/// @description Duplicate a save — what a "branch here" or a backup does.
function save_slots_copy(from_slot, to_slot) {
    var _data = save_slots_read(from_slot, undefined);
    if (_data == undefined) return false;
    return save_slots_write(to_slot, _data);
}
