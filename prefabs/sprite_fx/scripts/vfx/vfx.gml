// The in-game host for `kind = "subject"` shaders; see README.md.
// Every texture has (0, 0) at the capture's visual top-left, whichever way
// the runtime stores its surfaces.

// Public API. `_fx` is what vfx_create returned.

/// A new effect instance for a `[host] kind = "subject"` shader.
function vfx_create(_shader) {
    var _host = shader_get_host(_shader);
    if (is_undefined(_host) || _host.kind != "subject") {
        show_error("vfx_create: " + shader_get_name(_shader) + " is not a subject shader ([host] kind = \"subject\" in its shader.toml)", true);
    }
    var _fx = {
        shader: _shader,
        margin: _host.margin,
        linger: _host.linger,
        drift: _host.drift,
        snapshot: _host.snapshot,
        values: shader_get_uniform_defaults(_shader),
        uniforms: {},
        u_time: -1,
        u_margin: -1,
        u_resolution: -1,
        s_dist: -1,
        s_seed: -1,
        uses_field: false,
        time: 0,
        time_set: false,
        last_time: 0,
        dt: 0,
        cycle: -1,
        primed: false,
        scale: 1,
        res: 0,
        box: [0, 0, 0],
        hull: undefined,
        key: undefined,
        reuse: false,
        capture: -1,
        subject: -1,
        seed: [-1, -1],
        dist: [-1, -1],
        cam: camera_create_view(0, 0, 1, 1),
        drawing: false,
        saved: undefined,
    };
    var _bind = _host.bind;
    if (variable_struct_exists(_bind, "time")) _fx.u_time = shader_get_uniform(_shader, _bind.time);
    if (variable_struct_exists(_bind, "margin")) _fx.u_margin = shader_get_uniform(_shader, _bind.margin);
    if (variable_struct_exists(_bind, "resolution")) _fx.u_resolution = shader_get_uniform(_shader, _bind.resolution);
    if (variable_struct_exists(_bind, "dist")) _fx.s_dist = shader_get_sampler_index(_shader, _bind.dist);
    if (variable_struct_exists(_bind, "seed")) _fx.s_seed = shader_get_sampler_index(_shader, _bind.seed);
    _fx.uses_field = _fx.s_dist >= 0 || _fx.s_seed >= 0;
    var _list = _host.uniforms;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _u = _list[_i];
        // A sampler's handle is a texture stage; its value is a sprite.
        var _handle = _u.type == "sampler"
            ? shader_get_sampler_index(_shader, _u.name)
            : shader_get_uniform(_shader, _u.name);
        _fx.uniforms[$ _u.name] = { handle: _handle, type: _u.type };
    }
    return _fx;
}

/// Frees the instance's surfaces.
function vfx_destroy(_fx) {
    __vfx_free_surfaces(_fx);
    camera_destroy(_fx.cam);
    _fx.shader = -1;
}

function vfx_exists(_fx) {
    return is_struct(_fx) && variable_struct_exists(_fx, "cam") && _fx.shader >= 0;
}

/// Sets `[[uniform]]` `_name`: a number, a bool, an array, or a sprite.
function vfx_set(_fx, _name, _value) {
    if (!variable_struct_exists(_fx.uniforms, _name)) {
        show_error("vfx_set: " + shader_get_name(_fx.shader) + " has no uniform " + _name, true);
    }
    _fx.values[$ _name] = _value;
}

function vfx_get(_fx, _name) {
    if (!variable_struct_exists(_fx.uniforms, _name)) {
        show_error("vfx_get: " + shader_get_name(_fx.shader) + " has no uniform " + _name, true);
    }
    return _fx.values[$ _name];
}

/// The effect clock in seconds; unless set, it advances by delta_time on each draw.
function vfx_set_time(_fx, _seconds) {
    _fx.time = _seconds;
    _fx.time_set = true;
}

function vfx_get_time(_fx) {
    return _fx.time;
}

/// Forgets the field and draw_rig_vfx's box.
function vfx_retake(_fx) {
    _fx.primed = false;
    _fx.key = undefined;
    _fx.hull = undefined;
}

/// Capture resolution relative to screen pixels; 1 by default.
function vfx_set_scale(_fx, _scale) {
    _fx.scale = _scale;
}

/// Starts capturing the room box; returns false when `_key` matches the held
/// capture's, and the caller skips its drawing.
function vfx_begin(_fx, _x, _y, _w, _h, _key = undefined) {
    if (_fx.drawing) show_error("vfx_begin: already drawing into this effect (missing vfx_end?)", true);
    var _side = max(_w, _h);
    var _full = _side * (1 + 2 * _fx.margin);
    _fx.box = [_x + (_w - _full) / 2, _y + (_h - _full) / 2, _full];
    var _res = min(2048, ceil(_full * __vfx_zoom() * _fx.scale / 32) * 32);
    __vfx_surfaces(_fx, _res);
    _fx.saved = {
        blend: gpu_get_blendmode_ext_sepalpha(),
        texrepeat: gpu_get_texrepeat(),
        texfilter: gpu_get_texfilter(),
    };
    _fx.reuse = !is_undefined(_key) && __vfx_same_key(_key, _fx.key);
    _fx.key = _key;
    _fx.drawing = true;
    if (_fx.reuse) return false;
    surface_set_target(_fx.capture);
    draw_clear_alpha(c_black, 0);
    gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
    camera_set_view_pos(_fx.cam, _fx.box[0], _fx.box[1]);
    camera_set_view_size(_fx.cam, _full, _full);
    camera_apply(_fx.cam);
    return true;
}

/// Ends the capture, updates the field and draws the shader over the box.
function vfx_end(_fx) {
    __vfx_end(_fx, c_white, 1);
}

/// draw_sprite_ext through the effect; `_colour` and `_alpha` tint the composite.
function draw_sprite_vfx(_fx, _sprite, _subimg, _x, _y, _xscale, _yscale, _rot, _colour, _alpha) {
    var _w = sprite_get_width(_sprite);
    var _h = sprite_get_height(_sprite);
    var _l = -sprite_get_xoffset(_sprite) * _xscale;
    var _t = -sprite_get_yoffset(_sprite) * _yscale;
    var _r = _l + _w * _xscale;
    var _b = _t + _h * _yscale;
    var _key = [_sprite, floor(_subimg), _xscale, _yscale, _rot];
    var _draw;
    if (_rot == 0) {
        _draw = vfx_begin(_fx, _x + min(_l, _r), _y + min(_t, _b), _w * abs(_xscale), _h * abs(_yscale), _key);
    } else {
        var _reach = sqrt(max(_l * _l, _r * _r) + max(_t * _t, _b * _b));
        _draw = vfx_begin(_fx, _x - _reach, _y - _reach, 2 * _reach, 2 * _reach, _key);
    }
    if (_draw) draw_sprite_ext(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, c_white, 1);
    __vfx_end(_fx, _colour, _alpha);
}

/// draw_rig through the effect; the box grows to hold every pose seen.
function draw_rig_vfx(_fx, _rig) {
    var _bounds = rig_get_bounds(_rig);
    if (array_length(_bounds) < 4) {
        draw_rig(_rig);
        return;
    }
    var _rx = rig_get_x(_rig);
    var _ry = rig_get_y(_rig);
    var _seen = [
        floor((_bounds[0] - _rx) / 16) * 16, floor((_bounds[1] - _ry) / 16) * 16,
        ceil((_bounds[2] - _rx) / 16) * 16, ceil((_bounds[3] - _ry) / 16) * 16,
    ];
    var _hull = _fx.hull;
    if (!is_undefined(_hull)) {
        _seen = [min(_hull[0], _seen[0]), min(_hull[1], _seen[1]), max(_hull[2], _seen[2]), max(_hull[3], _seen[3])];
    }
    if (is_undefined(_hull) || !array_equals(_hull, _seen)) {
        _fx.hull = _seen;
        _fx.primed = false;
    }
    _hull = _seen;
    vfx_begin(_fx, _rx + _hull[0], _ry + _hull[1], _hull[2] - _hull[0], _hull[3] - _hull[1]);
    draw_rig(_rig);
    vfx_end(_fx);
}

// Internals.

/// Distance clamp of the resolve pass, in texture units.
#macro __VFX_FAR 4

/// Field updates.
#macro __VFX_FOLLOW 0
#macro __VFX_HOLD 1
#macro __VFX_RETAKE 2

/// State shared by every instance.
function __vfx_env() {
    if (!variable_global_exists("__sprite_fx_env")) {
        global.__sprite_fx_env = {
            field_format: __vfx_field_format(),
            flip: __vfx_probe_flip(),
            u_step: shader_get_uniform(shd_vfx_jfa, "uStep"),
            u_grow: shader_get_uniform(shd_vfx_resolve, "uGrow"),
            u_drift: shader_get_uniform(shd_vfx_resolve, "uDrift"),
            s_prev: shader_get_sampler_index(shd_vfx_resolve, "uPrev"),
        };
    }
    return global.__sprite_fx_env;
}

/// The finest format the runtime renders the field to.
function __vfx_field_format() {
    if (surface_format_is_supported(surface_rgba16float)) return surface_rgba16float;
    if (surface_format_is_supported(surface_rgb10a2unorm)) return surface_rgb10a2unorm;
    return surface_rgba8unorm;
}

/// Whether a surface's texture reads bottom-up.
function __vfx_probe_flip() {
    var _a = surface_create(8, 8);
    var _b = surface_create(8, 8);
    var _colour = draw_get_colour();
    var _alpha = draw_get_alpha();
    surface_set_target(_a);
    draw_clear_alpha(c_black, 1);
    draw_set_colour(c_white);
    draw_set_alpha(1);
    draw_rectangle(0, 0, 8, 3, false);
    surface_reset_target();
    surface_set_target(_b);
    draw_clear_alpha(c_black, 1);
    __vfx_quad(false, surface_get_texture(_a), 0, 0, 8, 8, c_white, 1);
    surface_reset_target();
    var _flip = colour_get_red(surface_getpixel(_b, 2, 1)) < 128;
    draw_set_colour(_colour);
    draw_set_alpha(_alpha);
    surface_free(_a);
    surface_free(_b);
    return _flip;
}

/// Draws `_tex` over the box with v_vTexcoord (0, 0) at its visual top-left.
function __vfx_quad(_flip, _tex, _x, _y, _w, _h, _colour, _alpha) {
    var _v0 = _flip ? 1 : 0;
    var _v1 = 1 - _v0;
    draw_primitive_begin_texture(pr_trianglestrip, _tex);
    draw_vertex_texture_colour(_x, _y, 0, _v0, _colour, _alpha);
    draw_vertex_texture_colour(_x + _w, _y, 1, _v0, _colour, _alpha);
    draw_vertex_texture_colour(_x, _y + _h, 0, _v1, _colour, _alpha);
    draw_vertex_texture_colour(_x + _w, _y + _h, 1, _v1, _colour, _alpha);
    draw_primitive_end();
}

/// Screen pixels per room unit of the current target.
function __vfx_zoom() {
    var _proj = matrix_get(matrix_projection);
    var _view_w = abs(2 / _proj[0]);
    var _target = surface_get_target();
    var _port_w;
    if (surface_exists(_target)) _port_w = surface_get_width(_target);
    else if (view_enabled) _port_w = view_get_wport(view_current);
    else _port_w = window_get_width();
    return _port_w / _view_w;
}

/// (Re)creates the surfaces at `_res` when the size changed or any was lost.
function __vfx_surfaces(_fx, _res) {
    var _lost = !surface_exists(_fx.capture) || !surface_exists(_fx.subject)
        || !surface_exists(_fx.seed[0]) || !surface_exists(_fx.seed[1])
        || !surface_exists(_fx.dist[0]) || !surface_exists(_fx.dist[1]);
    if (_res == _fx.res && !_lost) return;
    var _env = __vfx_env();
    __vfx_free_surfaces(_fx);
    _fx.key = undefined;
    var _depth = surface_get_depth_disable();
    surface_depth_disable(true);
    _fx.res = _res;
    _fx.capture = surface_create(_res, _res);
    _fx.subject = surface_create(_res, _res);
    _fx.seed = [surface_create(_res, _res, _env.field_format), surface_create(_res, _res, _env.field_format)];
    _fx.dist = [surface_create(_res, _res, _env.field_format), surface_create(_res, _res, _env.field_format)];
    surface_depth_disable(_depth);
    // The priming frame grows the field past FAR; it only has to be finite.
    for (var _i = 0; _i < 2; _i++) {
        surface_set_target(_fx.dist[_i]);
        draw_clear_alpha(c_black, 0);
        surface_reset_target();
    }
    _fx.primed = false;
}

function __vfx_free_surfaces(_fx) {
    var _all = [_fx.capture, _fx.subject, _fx.seed[0], _fx.seed[1], _fx.dist[0], _fx.dist[1]];
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (surface_exists(_all[_i])) surface_free(_all[_i]);
    }
    _fx.capture = -1;
    _fx.subject = -1;
    _fx.seed = [-1, -1];
    _fx.dist = [-1, -1];
    _fx.res = 0;
}

/// What the field does this frame: a new snapshot cycle retakes it, the rest of the cycle holds it.
function __vfx_update(_fx) {
    var _rate = is_string(_fx.snapshot) ? _fx.values[$ _fx.snapshot] : _fx.snapshot;
    if (!is_real(_rate) || _rate <= 0) return __VFX_FOLLOW;
    var _cycle = floor(_fx.time * _rate);
    if (_cycle == _fx.cycle) return __VFX_HOLD;
    _fx.cycle = _cycle;
    return __VFX_RETAKE;
}

/// The field's velocity in texture units per second.
function __vfx_drift(_fx) {
    var _d = _fx.drift;
    if (is_string(_d)) _d = _fx.values[$ _d];
    return is_array(_d) && array_length(_d) >= 2 ? _d : [0, 0];
}

/// Whether two capture keys name the same subject.
function __vfx_same_key(_a, _b) {
    if (is_array(_a) && is_array(_b)) return array_equals(_a, _b);
    return !is_array(_a) && !is_array(_b) && _a == _b;
}

function __vfx_set_uniform(_handle, _type, _value) {
    if (_handle < 0) return;
    switch (_type) {
        case "float": shader_set_uniform_f(_handle, _value); break;
        case "int": shader_set_uniform_i(_handle, _value); break;
        case "bool": shader_set_uniform_i(_handle, _value ? 1 : 0); break;
        case "sampler":
            // The sprite's first frame; an unset sampler is left alone.
            if (sprite_exists(_value)) texture_set_stage(_handle, sprite_get_texture(_value, 0));
            break;
        default: shader_set_uniform_f_array(_handle, _value); break;
    }
}

function __vfx_end(_fx, _colour, _alpha) {
    if (!_fx.drawing) show_error("vfx_end: not drawing into this effect (missing vfx_begin?)", true);
    var _reuse = _fx.reuse;
    if (!_reuse) surface_reset_target();
    _fx.drawing = false;
    _fx.reuse = false;

    if (!_fx.time_set) _fx.time += min(delta_time / 1000000, 0.1);
    _fx.time_set = false;
    _fx.dt = clamp(_fx.time - _fx.last_time, 0, 0.1);
    _fx.last_time = _fx.time;

    var _env = __vfx_env();
    var _res = _fx.res;
    gpu_set_blendmode_ext(bm_one, bm_zero);
    gpu_set_texrepeat(false);
    gpu_set_texfilter(false);

    if (!_reuse) {
        surface_set_target(_fx.subject);
        shader_set(shd_vfx_unpremult);
        __vfx_quad(_env.flip, surface_get_texture(_fx.capture), 0, 0, _res, _res, c_white, 1);
        shader_reset();
        surface_reset_target();
    }

    if (_fx.uses_field) __vfx_field(_fx, _env, _reuse);

    var _saved = _fx.saved;
    gpu_set_blendmode_ext_sepalpha(_saved.blend[0], _saved.blend[1], _saved.blend[2], _saved.blend[3]);
    gpu_set_texrepeat(_saved.texrepeat);
    gpu_set_texfilter(_saved.texfilter);
    __vfx_composite(_fx, _env, _colour, _alpha);
    if (_fx.s_dist >= 0) gpu_set_tex_filter_ext(_fx.s_dist, _saved.texfilter);
    if (_fx.s_seed >= 0) gpu_set_tex_filter_ext(_fx.s_seed, _saved.texfilter);
    _fx.saved = undefined;
}

/// Seeds → jump flood → resolve, newest at index 0 of each pair; with
/// `_seeded` only the resolve runs.
function __vfx_field(_fx, _env, _seeded) {
    var _update = __vfx_update(_fx);
    if (_update == __VFX_HOLD && _fx.primed) return;
    if (_update == __VFX_RETAKE) _fx.primed = false;
    if (_seeded && _fx.primed && _fx.linger <= 0) return;
    // The first frame primes the field with no lag.
    var _linger = _fx.primed ? _fx.linger : 0;
    var _dt = _fx.primed ? _fx.dt : 0;
    var _res = _fx.res;

    if (!_seeded) {
        surface_set_target(_fx.seed[0]);
        shader_set(shd_vfx_seed);
        __vfx_quad(_env.flip, surface_get_texture(_fx.subject), 0, 0, _res, _res, c_white, 1);
        shader_reset();
        surface_reset_target();

        var _src = 0;
        var _dst = 1;
        shader_set(shd_vfx_jfa);
        for (var _step = _res / 2; _step >= 1; _step = floor(_step / 2)) {
            surface_set_target(_fx.seed[_dst]);
            shader_set_uniform_f(_env.u_step, _step);
            __vfx_quad(_env.flip, surface_get_texture(_fx.seed[_src]), 0, 0, _res, _res, c_white, 1);
            surface_reset_target();
            var _t = _src;
            _src = _dst;
            _dst = _t;
        }
        shader_reset();
        _fx.seed = [_fx.seed[_src], _fx.seed[_dst]];
    }

    // With no linger the old field is discarded outright.
    var _grow = _linger > 0 ? 0.3 / _linger * _dt : __VFX_FAR;
    var _drift = __vfx_drift(_fx);
    surface_set_target(_fx.dist[1]);
    shader_set(shd_vfx_resolve);
    shader_set_uniform_f(_env.u_grow, _grow);
    shader_set_uniform_f(_env.u_drift, _drift[0] * _dt, _drift[1] * _dt);
    texture_set_stage(_env.s_prev, surface_get_texture(_fx.dist[0]));
    gpu_set_tex_filter_ext(_env.s_prev, true);
    __vfx_quad(_env.flip, surface_get_texture(_fx.seed[0]), 0, 0, _res, _res, c_white, 1);
    shader_reset();
    surface_reset_target();
    _fx.dist = [_fx.dist[1], _fx.dist[0]];
    _fx.primed = true;
}

/// The shader over the subject, drawn where the box was captured.
function __vfx_composite(_fx, _env, _colour, _alpha) {
    shader_set(_fx.shader);
    if (_fx.u_time >= 0) shader_set_uniform_f(_fx.u_time, _fx.time);
    if (_fx.u_margin >= 0) shader_set_uniform_f(_fx.u_margin, _fx.margin / (1 + 2 * _fx.margin));
    if (_fx.u_resolution >= 0) shader_set_uniform_f(_fx.u_resolution, _fx.res, _fx.res);
    if (_fx.s_dist >= 0) {
        texture_set_stage(_fx.s_dist, surface_get_texture(_fx.dist[0]));
        gpu_set_tex_filter_ext(_fx.s_dist, true);
    }
    if (_fx.s_seed >= 0) {
        texture_set_stage(_fx.s_seed, surface_get_texture(_fx.seed[0]));
        gpu_set_tex_filter_ext(_fx.s_seed, false);
    }
    var _names = variable_struct_get_names(_fx.uniforms);
    for (var _i = 0; _i < array_length(_names); _i++) {
        var _u = _fx.uniforms[$ _names[_i]];
        __vfx_set_uniform(_u.handle, _u.type, _fx.values[$ _names[_i]]);
    }
    var _box = _fx.box;
    __vfx_quad(_env.flip, surface_get_texture(_fx.subject), _box[0], _box[1], _box[2], _box[2], _colour, _alpha);
    shader_reset();
}
