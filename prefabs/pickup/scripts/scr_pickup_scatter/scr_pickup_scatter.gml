/// @function pickup_scatter(obj, count, from_x, from_y, spread)
/// @description Drop `count` of `obj` around a point, jittered within
/// `spread` and kept inside the room. What a destroyed enemy leaves behind.
function pickup_scatter(obj, count, from_x, from_y, spread) {
    var _made = [];
    for (var i = 0; i < count; i++) {
        var _dir = irandom(359);
        var _len = random(spread);
        var _px = clamp(from_x + lengthdir_x(_len, _dir), 8, room_width - 8);
        var _py = clamp(from_y + lengthdir_y(_len, _dir), 8, room_height - 8);
        array_push(_made, instance_create_depth(_px, _py, 0, obj));
    }
    return _made;
}

/// @function pickup_remaining(obj)
/// @description How many are still uncollected — the number a "collect them
/// all" objective is checking.
function pickup_remaining(obj) {
    return instance_number(obj);
}
