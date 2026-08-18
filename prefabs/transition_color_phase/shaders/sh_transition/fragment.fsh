#version 300 es
precision highp float;

// sh_transition — effect: color-phase.
// Adapted from gl-transitions `colorphase.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/colorphase.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec4 from_step = vec4(0.0, 0.2, 0.4, 0.0);
const vec4 to_step   = vec4(0.6, 0.8, 1.0, 1.0);

vec4 transition(vec2 uv) {
    vec4 a = getFromColor(uv);
    vec4 b = getToColor(uv);
    return mix(a, b, smoothstep(from_step, to_step, vec4(progress)));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
