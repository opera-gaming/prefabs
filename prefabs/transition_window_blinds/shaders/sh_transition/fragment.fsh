#version 300 es
precision highp float;

// sh_transition — effect: window-blinds.
// Adapted from gl-transitions `windowblinds.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/windowblinds.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec4 transition (vec2 uv) {
  float t = progress;

  if (mod(floor(uv.y*100.*progress),2.)==0.)
    t*=2.-.5;

  return mix(
    getFromColor(uv),
    getToColor(uv),
    mix(t, progress, smoothstep(0.8, 1.0, progress))
  );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
