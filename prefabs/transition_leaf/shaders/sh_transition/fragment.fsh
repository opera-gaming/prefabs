#version 300 es
precision highp float;

// sh_transition — effect: leaf.
// Adapted from gl-transitions `cannabisleaf.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/cannabisleaf.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec4 transition(vec2 uv) {
    if (progress == 0.0) {
        return getFromColor(uv);
    }
    vec2 leaf_uv = (uv - vec2(0.5)) / 10.0 / pow(progress, 3.5);
    leaf_uv.y += 0.35;
    float r = 0.18;
    float o = atan(leaf_uv.y, leaf_uv.x);
    return mix(getFromColor(uv), getToColor(uv),
        1.0 - step(1.0 - length(leaf_uv) + r * (1.0 + sin(o)) * (1.0 + 0.9 * cos(8.0 * o)) * (1.0 + 0.1 * cos(24.0 * o)) * (0.9 + 0.05 * cos(200.0 * o)), 1.0));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
