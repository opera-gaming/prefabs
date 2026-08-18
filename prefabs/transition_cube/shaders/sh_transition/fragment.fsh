#version 300 es
precision highp float;

// sh_transition — effect: cube.
// Adapted from gl-transitions `cube.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/cube.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float persp;       // knob; default in scr_transition_defaults
uniform float unzoom;      // knob; default in scr_transition_defaults
uniform float reflection;  // knob; default in scr_transition_defaults
uniform float floating;    // knob; default in scr_transition_defaults

vec2 project(vec2 p) {
    float fl = floating;
    return p * vec2(1.0, -1.2) + vec2(0.0, -fl / 100.0);
}

bool inBounds(vec2 p) {
    return all(lessThan(vec2(0.0), p)) && all(lessThan(p, vec2(1.0)));
}

vec4 bgColor(vec2 p, vec2 pfr, vec2 pto) {
    float refl = reflection;
    vec4 c = vec4(0.0, 0.0, 0.0, 1.0);
    pfr = project(pfr);
    if (inBounds(pfr)) {
        c += mix(vec4(0.0), getFromColor(pfr), refl * mix(1.0, 0.0, pfr.y));
    }
    pto = project(pto);
    if (inBounds(pto)) {
        c += mix(vec4(0.0), getToColor(pto), refl * mix(1.0, 0.0, pto.y));
    }
    return c;
}

// p : the position
// persp : the perspective in [ 0, 1 ]
// center : the xcenter in [0, 1] \ 0.5 excluded
vec2 xskew(vec2 p, float persp, float center) {
    float x = mix(p.x, 1.0 - p.x, center);
    return (
        (
            vec2(x, (p.y - 0.5 * (1.0 - persp) * x) / (1.0 + (persp - 1.0) * x))
            - vec2(0.5 - distance(center, 0.5), 0.0)
        )
        * vec2(0.5 / distance(center, 0.5) * (center < 0.5 ? 1.0 : -1.0), 1.0)
        + vec2(center < 0.5 ? 0.0 : 1.0, 0.0)
    );
}

vec4 transition(vec2 op) {
    float prsp = persp;
    float uzoom = unzoom;
    float uz = uzoom * 2.0 * (0.5 - distance(0.5, progress));
    vec2 p = -uz * 0.5 + (1.0 + uz) * op;
    vec2 fromP = xskew(
        (p - vec2(progress, 0.0)) / vec2(1.0 - progress, 1.0),
        1.0 - mix(progress, 0.0, prsp),
        0.0
    );
    vec2 toP = xskew(
        p / vec2(progress, 1.0),
        mix(pow(progress, 2.0), 1.0, prsp),
        1.0
    );
    if (inBounds(fromP)) {
        return getFromColor(fromP);
    } else if (inBounds(toP)) {
        return getToColor(toP);
    }
    return bgColor(op, fromP, toP);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
