#version 300 es
precision highp float;

// sh_transition — effect: polka-dots-curtain.
// Adapted from gl-transitions `PolkaDotsCurtain.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PolkaDotsCurtain.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

const float SQRT_2 = 1.414213562373;
uniform float dots;   // knob; default in scr_transition_defaults
const vec2 center = vec2(0.0, 0.0);

vec4 transition(vec2 uv) {
  float d = dots;
  bool nextImage = distance(fract(uv * d), vec2(0.5, 0.5)) < (progress / distance(uv, center));
  return nextImage ? getToColor(uv) : getFromColor(uv);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
