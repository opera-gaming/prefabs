#version 300 es
precision highp float;

// sh_transition — effect: window-slice.
// Adapted from gl-transitions `windowslice.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/windowslice.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float count;        // knob; default in scr_transition_defaults
uniform float smoothness;   // knob; default in scr_transition_defaults

vec4 transition (vec2 p) {
  float cnt = count;
  float sm  = smoothness;
  float pr = smoothstep(-sm, 0.0, p.x - progress * (1.0 + sm));
  float s = step(pr, fract(cnt * p.x));
  return mix(getFromColor(p), getToColor(p), s);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
