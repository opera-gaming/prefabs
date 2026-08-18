#version 300 es
precision highp float;

// sh_transition — effect: fade-grayscale.
// Adapted from gl-transitions `fadegrayscale.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/fadegrayscale.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float intensity;   // knob; default in scr_transition_defaults

vec3 grayscale (vec3 color) {
  return vec3(0.2126*color.r + 0.7152*color.g + 0.0722*color.b);
}

vec4 transition (vec2 uv) {
  float inten = intensity;
  vec4 fc = getFromColor(uv);
  vec4 tc = getToColor(uv);
  return mix(
    mix(vec4(grayscale(fc.rgb), 1.0), fc, smoothstep(1.0-inten, 0.0, progress)),
    mix(vec4(grayscale(tc.rgb), 1.0), tc, smoothstep(    inten, 1.0, progress)),
    progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
