#version 300 es
precision highp float;

// sh_transition — effect: random-squares.
// Adapted from gl-transitions `randomsquares.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/randomsquares.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

// size is a vec2 param (default [10,10]) — baked as a const.
const vec2 size = vec2(10.0, 10.0);
uniform float smoothness;   // knob; default in scr_transition_defaults

float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 transition(vec2 p) {
  float sm = smoothness;
  float r = rand(floor(vec2(size) * p));
  float m = smoothstep(0.0, -sm, r - (progress * (1.0 + sm)));
  return mix(getFromColor(p), getToColor(p), m);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
