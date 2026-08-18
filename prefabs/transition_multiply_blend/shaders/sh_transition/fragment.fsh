#version 300 es
precision highp float;

// sh_transition — effect: multiply-blend.
// Adapted from gl-transitions `multiply_blend.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/multiply_blend.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec4 blend(vec4 a, vec4 b) {
  return a * b;
}

vec4 transition (vec2 uv) {

  vec4 blended = blend(getFromColor(uv), getToColor(uv));

  if (progress < 0.5)
    return mix(getFromColor(uv), blended, 2.0 * progress);
  else
    return mix(blended, getToColor(uv), 2.0 * progress - 1.0);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
