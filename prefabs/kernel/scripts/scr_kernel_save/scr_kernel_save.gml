/// Persistent store plus run-scoped flags. One file, one struct, so a
/// pack that wants to remember something does not invent a format.

/// @function kernel_save_file()
function kernel_save_file() {
    return "kernel_save.json";
}

/// @function kernel_save_load()
/// @description Read the save file into memory. Missing or corrupt file
/// is not an error — it is a first run, and a game that refuses to start
/// because its save is bad is worse than one that starts fresh.
function kernel_save_load() {
    global.kernel_save = {};
    if (!file_exists(kernel_save_file())) return;

    var _f = file_text_open_read(kernel_save_file());
    var _raw = "";
    while (!file_text_eof(_f)) {
        _raw += file_text_read_string(_f);
        file_text_readln(_f);
    }
    file_text_close(_f);

    try {
        var _parsed = json_parse(_raw);
        if (is_struct(_parsed)) global.kernel_save = _parsed;
    } catch (_e) {
        global.kernel_save = {};
    }
}

/// @function kernel_save_flush()
function kernel_save_flush() {
    var _f = file_text_open_write(kernel_save_file());
    file_text_write_string(_f, json_stringify(global.kernel_save));
    file_text_close(_f);
}

/// @function kernel_save_get(key, fallback)
function kernel_save_get(key, fallback = 0) {
    if (!variable_struct_exists(global.kernel_save, key)) return fallback;
    return global.kernel_save[$ key];
}

/// @function kernel_save_set(key, value)
/// @description Write and flush. Flushing every write is fine at this
/// scale and means a crash never loses a high score.
function kernel_save_set(key, value) {
    global.kernel_save[$ key] = value;
    kernel_save_flush();
}

/// @function kernel_save_high_score(score)
/// @description Record `score` if it beats the stored best. Returns
/// true when it was a new best, so the results screen can say so.
function kernel_save_high_score(score) {
    if (score <= kernel_save_get("high_score", 0)) return false;
    kernel_save_set("high_score", score);
    return true;
}

/// @function kernel_flag_get(name)
/// @description Run-scoped flag. Cleared by kernel_boot, never written
/// to disk — this is "has the player seen the tutorial this run", not
/// "has the player ever finished the game".
function kernel_flag_get(name) {
    if (!variable_struct_exists(global.kernel_flags, name)) return false;
    return global.kernel_flags[$ name];
}

/// @function kernel_flag_set(name, value)
function kernel_flag_set(name, value = true) {
    global.kernel_flags[$ name] = value;
}
