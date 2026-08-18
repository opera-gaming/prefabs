#version 300 es
precision highp float;

// sh_transition — effect: squares-wire.
// Adapted from gl-transitions `squareswire.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/squareswire.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const vec2 squares = vec2(10.0, 10.0);
const vec2 direction = vec2(1.0, -0.5);
uniform float smoothness;   // knob; default in scr_transition_defaults

const vec2 center = vec2(0.5, 0.5);
vec4 transition(vec2 p) {
    float sm = smoothness;
    vec2 v = normalize(direction);
    v /= abs(v.x) + abs(v.y);
    float d = v.x * center.x + v.y * center.y;
    float offset = sm;
    float pr = smoothstep(-offset, 0.0, v.x * p.x + v.y * p.y - (d - 0.5 + progress * (1. + offset)));
    vec2 squarep = fract(p * vec2(squares));
    vec2 squaremin = vec2(pr / 2.0);
    vec2 squaremax = vec2(1.0 - pr / 2.0);
    float a = (1.0 - step(progress, 0.0)) * step(squaremin.x, squarep.x) * step(squaremin.y, squarep.y) * step(squarep.x, squaremax.x) * step(squarep.y, squaremax.y);
    return mix(getFromColor(p), getToColor(p), a);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
