#version 300 es
precision highp float;

// sh_transition — effect: zoom-in-circles.
// Adapted from gl-transitions `ZoomInCircles.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ZoomInCircles.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;
uniform float ratio;   // aspect ratio; supplied by transition-base machinery

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec2 zoom(vec2 uv, float amount) {
  return 0.5 + ((uv - 0.5) * amount);
}

vec4 transition(vec2 uv) {
  float rr = (ratio == 0.0) ? 1.0 : ratio;
  vec2 ratio2 = vec2(1.0, 1.0 / rr);
  vec2 r = 2.0 * ((vec2(uv.xy) - 0.5) * ratio2);
  float pro = progress / 0.8;
  float z = pro * 0.2;
  float t = 0.0;
  if (pro > 1.0) {
    z = 0.2 + (pro - 1.0) * 5.;
    t = clamp((progress - 0.8) / 0.07, 0.0, 1.0);
  }
  if (length(r) < 0.5+z) {
    // uv = zoom(uv, 0.9 - 0.1 * pro);
  }
  else if (length(r) < 0.8+z*1.5) {
    uv = zoom(uv, 1.0 - 0.15 * pro);
    t = t * 0.5;
  }
  else if (length(r) < 1.2+z*2.5) {
    uv = zoom(uv, 1.0 - 0.2 * pro);
    t = t * 0.2;
  }
  else {
    uv = zoom(uv, 1.0 - 0.25 * pro);
  }
  return mix(getFromColor(uv), getToColor(uv), t);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
