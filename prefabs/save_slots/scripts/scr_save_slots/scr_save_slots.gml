/// Several saved games, and the screen that lists them.
///
/// Writing to a temporary file and moving it into place is not caution for
/// its own sake: a crash partway through a write leaves a file that exists,
/// parses as nothing, and takes the save with it. The player loses hours to
/// a bug they will never be able to describe.

/// @function save_slots_path(slot)
/// @description The filename a slot uses.
function save_slots_path(slot) {
    return "save_" + string(slot) + ".json";
}

/// @function save_slots_exists(slot)
function save_slots_exists(slot) {
    return file_exists(save_slots_path(slot));
}

/// @function save_slots_write(slot, data)
/// @description Write a struct to a slot. Returns whether it was written.
///
/// Goes to a temporary file first and is moved into place once complete, so
/// a crash mid-write cannot leave a half-written save that parses as
/// nothing and destroys the old one with it.
function save_slots_write(slot, data) {
    var _final = save_slots_path(slot);
    var _temp = _final + ".part";
    var _f = file_text_open_write(_temp);
    if (_f < 0) return false;
    file_text_write_string(_f, json_stringify(data));
    file_text_close(_f);

    if (file_exists(_final)) file_delete(_final);
    file_rename(_temp, _final);
    return file_exists(_final);
}

/// @function save_slots_read(slot, fallback)
/// @description The struct in a slot, or `fallback` when it is empty or
/// unreadable. A corrupt save starts a new game rather than ending the
/// session — which takes a guard, because the obvious `try`/`catch` around
/// `json_parse` does not work (see below).
function save_slots_read(slot, fallback) {
    var _path = save_slots_path(slot);
    if (!file_exists(_path)) return fallback;

    var _f = file_text_open_read(_path);
    if (_f < 0) return fallback;
    var _text = "";
    while (!file_text_eof(_f)) {
        _text += file_text_read_string(_f);
        file_text_readln(_f);
    }
    file_text_close(_f);

    // Checked *before* parsing, not caught after. `json_parse` on malformed
    // input raises an error `try`/`catch` cannot intercept — measured on the
    // runner: a plain `throw` is caught, and a bad `json_parse` in the same
    // shape kills the game. So a guard is the only thing standing between a
    // truncated save and a session that ends when the player loads it.
    if (!save_slots_looks_like_json(_text)) return fallback;

    var _data = json_parse(_text);
    return is_struct(_data) ? _data : fallback;
}

/// @function save_slots_looks_like_json(text)
/// @description Whether `text` is structurally plausible as a JSON object:
/// non-empty, braced, and balanced outside of strings.
///
/// Not a parser, and not trying to be — it exists to reject the corruption
/// that actually happens, which is a file truncated by a crash or a disk
/// filling up. Anything that gets past it is `json_parse`'s problem, and
/// `is_struct` catches the rest.
function save_slots_looks_like_json(text) {
    var _t = string_trim(text);
    var _n = string_length(_t);
    if (_n < 2) return false;
    if (string_char_at(_t, 1) != "{" || string_char_at(_t, _n) != "}") return false;

    var _depth = 0;
    var _in_string = false;
    var _escaped = false;
    for (var i = 1; i <= _n; i++) {
        var _c = string_char_at(_t, i);
        if (_escaped) { _escaped = false; continue; }
        if (_in_string) {
            if (_c == "\\") _escaped = true;
            else if (_c == "\"") _in_string = false;
            continue;
        }
        switch (_c) {
            case "\"": _in_string = true; break;
            case "{": case "[": _depth += 1; break;
            case "}": case "]":
                _depth -= 1;
                if (_depth < 0) return false;
                break;
        }
    }
    return _depth == 0 && !_in_string;
}

/// @function save_slots_delete(slot)
function save_slots_delete(slot) {
    var _path = save_slots_path(slot);
    if (!file_exists(_path)) return false;
    file_delete(_path);
    return true;
}

