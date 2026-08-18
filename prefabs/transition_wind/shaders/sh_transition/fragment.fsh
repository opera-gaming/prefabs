#version 300 es
precision highp float;

// sh_transition — effect: wind.
// Adapted from gl-transitions `wind.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/wind.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float size;   // knob; default in scr_transition_defaults

float rand (vec2 co) {
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 transition (vec2 uv) {
  float sz = size;
  float r = rand(vec2(0, uv.y));
  float m = smoothstep(0.0, -sz, uv.x*(1.0-sz) + sz*r - (progress * (1.0 + sz)));
  return mix(
    getFromColor(uv),
    getToColor(uv),
    m
  );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
