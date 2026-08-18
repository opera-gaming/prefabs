#version 300 es
precision highp float;

// sh_transition — effect: heart.
// Adapted from gl-transitions `heart.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/heart.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

float inHeart(vec2 p, vec2 center, float size) {
    if (size == 0.0) return 0.0;
    vec2 o = (p - center) / (1.6 * size);
    float a = o.x * o.x + o.y * o.y - 0.3;
    return step(a * a * a, o.x * o.x * o.y * o.y * o.y);
}

vec4 transition(vec2 uv) {
    return mix(
        getFromColor(uv),
        getToColor(uv),
        inHeart(uv, vec2(0.5, 0.4), progress));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
