#version 300 es
precision highp float;

// sh_transition — effect: dreamy.
// Adapted from gl-transitions `Dreamy.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Dreamy.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec2 offset(float progress, float x, float theta) {
  float phase = progress*progress + progress + theta;
  float shifty = 0.03*progress*cos(10.0*(progress+x));
  return vec2(0, shifty);
}

vec4 transition(vec2 p) {
  return mix(
    getFromColor(p + offset(progress, p.x, 0.0)),
    getToColor(p + offset(1.0-progress, p.x, 3.14)),
    progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
