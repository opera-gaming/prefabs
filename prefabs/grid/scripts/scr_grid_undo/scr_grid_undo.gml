/// @function grid_snapshot(g)
/// @description A restorable copy of the board's contents. This is what
/// makes undo and restart the same mechanism.
function grid_snapshot(g) {
    var _copy = array_create(array_length(g.cells));
    array_copy(_copy, 0, g.cells, 0, array_length(g.cells));
    return _copy;
}

/// @function grid_restore(g, snapshot)
function grid_restore(g, snapshot) {
    array_copy(g.cells, 0, snapshot, 0, array_length(snapshot));
}
