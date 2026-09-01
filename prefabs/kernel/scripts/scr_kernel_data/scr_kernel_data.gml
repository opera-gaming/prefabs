/// The data-plane seam.
///
/// A template's content tables and tuning knobs are generated into the
/// project as GML, under a name derived from the template slug — which
/// a component cannot know. So the project registers them here at boot
/// and every component reads through these two accessors instead.
///
/// That indirection is the point: when content moves from generated GML
/// to a real `data/` resource kind, the generator changes and not one
/// line of component GML does.

/// @function kernel_data_source(data_fn, tuning_struct)
/// @description Register the generated accessors. `data_fn` takes a
/// table name and returns it; `tuning_struct` is a flat struct of knobs.
function kernel_data_source(data_fn, tuning_struct) {
    global.kernel_data_fn = data_fn;
    global.kernel_tuning = tuning_struct;
}

/// @function kernel_data(name)
/// @description A content table by name, or an empty array when the
/// template did not declare one — callers iterate, so an empty array is
/// the useful absence.
function kernel_data(name) {
    if (global.kernel_data_fn == undefined) return [];
    var _t = global.kernel_data_fn(name);
    return (_t == undefined) ? [] : _t;
}

/// @function kernel_tuning(key, fallback)
/// @description One tuning knob. The fallback keeps a component working
/// against a template that has not declared the knob yet.
function kernel_tuning(key, fallback = 0) {
    if (!variable_struct_exists(global.kernel_tuning, key)) return fallback;
    return global.kernel_tuning[$ key];
}
