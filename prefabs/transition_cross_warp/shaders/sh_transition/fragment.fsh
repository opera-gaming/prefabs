#version 300 es
precision highp float;

// sh_transition — effect: cross-warp.
// Adapted from gl-transitions `crosswarp.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/crosswarp.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec4 transition(vec2 p) {
    float x = progress;
    x = smoothstep(0.0, 1.0, (x * 2.0 + p.x - 1.0));
    return mix(getFromColor((p - 0.5) * (1.0 - x) + 0.5), getToColor((p - 0.5) * x + 0.5), x);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
