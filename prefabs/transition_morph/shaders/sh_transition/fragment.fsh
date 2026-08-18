#version 300 es
precision highp float;

// sh_transition — effect: morph.
// Adapted from gl-transitions `morph.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/morph.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float strength;   // knob; default in scr_transition_defaults

vec4 transition(vec2 p) {
  float s = strength;
  vec4 ca = getFromColor(p);
  vec4 cb = getToColor(p);

  vec2 oa = (((ca.rg+ca.b)*0.5)*2.0-1.0);
  vec2 ob = (((cb.rg+cb.b)*0.5)*2.0-1.0);
  vec2 oc = mix(oa,ob,0.5)*s;

  float w0 = progress;
  float w1 = 1.0-w0;
  return mix(getFromColor(p+oc*w0), getToColor(p-oc*w1), progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
