#version 300 es
precision highp float;

// sh_transition — effect: swap.
// Adapted from gl-transitions `swap.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/swap.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float reflection;    // knob; default in scr_transition_defaults
uniform float perspective;   // knob; default in scr_transition_defaults
uniform float depth;         // knob; default in scr_transition_defaults

const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
const vec2 boundMin = vec2(0.0, 0.0);
const vec2 boundMax = vec2(1.0, 1.0);

bool inBounds(vec2 p) {
    return all(lessThan(boundMin, p)) && all(lessThan(p, boundMax));
}

vec2 project(vec2 p) {
    return p * vec2(1.0, -1.2) + vec2(0.0, -0.02);
}

vec4 bgColor(vec2 p, vec2 pfr, vec2 pto, float refl) {
    vec4 c = black;
    pfr = project(pfr);
    if (inBounds(pfr)) {
        c += mix(black, getFromColor(pfr), refl * mix(1.0, 0.0, pfr.y));
    }
    pto = project(pto);
    if (inBounds(pto)) {
        c += mix(black, getToColor(pto), refl * mix(1.0, 0.0, pto.y));
    }
    return c;
}

vec4 transition(vec2 p) {
    float refl = reflection;
    float pspec = perspective;
    float dpth = depth;

    vec2 pfr, pto = vec2(-1.);

    float size = mix(1.0, dpth, progress);
    float persp = pspec * progress;
    pfr = (p + vec2(-0.0, -0.5)) * vec2(size / (1.0 - pspec * progress), size / (1.0 - size * persp * p.x)) + vec2(0.0, 0.5);

    size = mix(1.0, dpth, 1. - progress);
    persp = pspec * (1. - progress);
    pto = (p + vec2(-1.0, -0.5)) * vec2(size / (1.0 - pspec * (1.0 - progress)), size / (1.0 - size * persp * (0.5 - p.x))) + vec2(1.0, 0.5);

    if (progress < 0.5) {
        if (inBounds(pfr)) {
            return getFromColor(pfr);
        }
        if (inBounds(pto)) {
            return getToColor(pto);
        }
    }
    if (inBounds(pto)) {
        return getToColor(pto);
    }
    if (inBounds(pfr)) {
        return getFromColor(pfr);
    }
    return bgColor(p, pfr, pto, refl);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
