#version 300 es
precision highp float;

// sh_transition — effect: ripple.
// Adapted from gl-transitions `ripple.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ripple.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float amplitude;   // knob; default in scr_transition_defaults
uniform float speed;       // knob; default in scr_transition_defaults

vec4 transition(vec2 uv) {
  float amp = amplitude;
  float spd = speed;
  vec2 dir = uv - vec2(.5);
  float dist = length(dir);
  vec2 offset = dir * (sin(progress * dist * amp - progress * spd) + .5) / 30.;
  return mix(
    getFromColor(uv + offset),
    getToColor(uv),
    smoothstep(0.2, 1.0, progress)
  );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
