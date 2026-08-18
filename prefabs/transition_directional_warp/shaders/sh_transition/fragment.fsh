#version 300 es
precision highp float;

// sh_transition — effect: directional-warp.
// Adapted from gl-transitions `directionalwarp.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/directionalwarp.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec2 direction = vec2(-1.0, 1.0);
const float smoothness = 0.5;
const vec2 center = vec2(0.5, 0.5);

vec4 transition(vec2 uv) {
    vec2 v = normalize(direction);
    v /= abs(v.x) + abs(v.y);
    float d = v.x * center.x + v.y * center.y;
    float m = 1.0 - smoothstep(-smoothness, 0.0, v.x * uv.x + v.y * uv.y - (d - 0.5 + progress * (1.0 + smoothness)));
    return mix(getFromColor((uv - 0.5) * (1.0 - m) + 0.5), getToColor((uv - 0.5) * m + 0.5), m);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
