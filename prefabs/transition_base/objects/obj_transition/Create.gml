// Size the capture surfaces to the real backing buffer. The correct source
// differs by target:
//   - Native (incl. macOS retina): application_get_position() gives the true
//     pixel rect. The application surface is retina-scaled here and mis-sizes.
//   - GX / WASM: application_get_position() is buggy on GX (returns the canvas
//     rect), so read the application surface's backing dimensions instead.
var w, h;
if (os_type == os_operagx) {
    w = surface_get_width(application_surface);
    h = surface_get_height(application_surface);
} else {
    var app = application_get_position();
    w = app[2] - app[0];
    h = app[3] - app[1];
}
from_surface = surface_create(w, h);
to_surface   = surface_create(w, h);

t = 0.0;
target_room = -1;
fade_length = 1.0;
in_target = false;

u_progress = shader_get_uniform(sh_transition, "progress");
uniforms = [];   // each entry: [tag, loc, values]  tag 0 = int, 1 = float

// Build the extra-uniform list for this effect. Every tunable knob is a float
// uniform addressed by name; the effect's transition_defaults() supplies the
// fallbacks, and the caller's `params` (from goto()) override them by key. A
// knob therefore always resolves to a concrete value, so passing 0 is a real 0
// — not a "use the default" sentinel — and the defaults are discoverable from
// the effect's scr_transition_defaults script rather than buried in the shader.
configure = function(p) {
    uniforms = [];

    // Merge caller params over the effect's defaults (params win).
    var merged = transition_defaults();
    var given = variable_struct_get_names(p);
    for (var i = 0; i < array_length(given); i++) merged[$ given[i]] = p[$ given[i]];

    var keys = variable_struct_get_names(merged);
    for (var i = 0; i < array_length(keys); i++) {
        var loc = shader_get_uniform(sh_transition, keys[i]);
        array_push(uniforms, [1, loc, [merged[$ keys[i]]]]);
    }

    // Fixed uniforms: the two source textures (stages 0/1) + aspect ratio.
    // `ratio` is always the live display aspect; it is not a caller knob.
    array_push(uniforms, [0, shader_get_uniform(sh_transition, "from_tex"), [0]]);
    array_push(uniforms, [0, shader_get_uniform(sh_transition, "to_tex"), [1]]);
    array_push(uniforms, [1, shader_get_uniform(sh_transition, "ratio"), [display_get_width() / display_get_height()]]);
};

configure({});
