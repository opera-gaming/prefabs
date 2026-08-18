#version 300 es
precision highp float;

// sh_transition — effect: radial.
// Adapted from gl-transitions `Radial.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Radial.glsl
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

const float PI = 3.141592653589;

vec4 transition(vec2 p) {
  float sm = smoothness;
  vec2 rp = p * 2. - 1.;
  return mix(
    getToColor(p),
    getFromColor(p),
    smoothstep(0., sm, atan(rp.y, rp.x) - (progress - .5) * PI * 2.5)
  );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
