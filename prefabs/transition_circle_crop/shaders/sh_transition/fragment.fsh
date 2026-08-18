#version 300 es
precision highp float;

// sh_transition — effect: circle-crop.
// Adapted from gl-transitions `CircleCrop.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CircleCrop.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float ratio;   // aspect ratio; supplied by transition-base machinery
const vec4 bgcolor = vec4(0.0, 0.0, 0.0, 1.0);

vec4 transition(vec2 p) {
    float r = (ratio == 0.0) ? 1.0 : ratio;
    vec2 ratio2 = vec2(1.0, 1.0 / r);
    float s = pow(2.0 * abs(progress - 0.5), 3.0);
    float dist = length((vec2(p) - 0.5) * ratio2);
    return mix(
        progress < 0.5 ? getFromColor(p) : getToColor(p),
        bgcolor,
        step(s, dist)
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
