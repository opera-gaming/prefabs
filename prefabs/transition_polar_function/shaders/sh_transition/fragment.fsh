#version 300 es
precision highp float;

// sh_transition — effect: polar-function.
// Adapted from gl-transitions `polar_function.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/polar_function.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

#define PI 3.14159265359

// segments is an int param (default 5) — baked as a const.
const int segments = 5;

vec4 transition(vec2 uv) {
  float angle = atan(uv.y - 0.5, uv.x - 0.5) - 0.5 * PI;
  float normalized = (angle + 1.5 * PI) * (2.0 * PI);

  float radius = (cos(float(segments) * angle) + 4.0) / 4.0;
  float difference = length(uv - vec2(0.5, 0.5));

  if (difference > radius * progress)
    return getFromColor(uv);
  else
    return getToColor(uv);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
