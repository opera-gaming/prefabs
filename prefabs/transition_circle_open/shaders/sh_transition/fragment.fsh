#version 300 es
precision highp float;

// sh_transition — effect: circle-open.
// Adapted from gl-transitions `circleopen.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/circleopen.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float smoothness;   // knob; default in scr_transition_defaults
const bool opening = true;
const vec2 center = vec2(0.5, 0.5);
const float SQRT_2 = 1.414213562373;

vec4 transition(vec2 uv) {
    float sm = smoothness;
    float x = opening ? progress : 1.0 - progress;
    float m = smoothstep(-sm, 0.0, SQRT_2 * distance(center, uv) - x * (1.0 + sm));
    return mix(getFromColor(uv), getToColor(uv), opening ? 1.0 - m : m);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
