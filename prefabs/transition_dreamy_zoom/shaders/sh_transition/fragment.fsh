#version 300 es
precision highp float;

// sh_transition — effect: dreamy-zoom.
// Adapted from gl-transitions `DreamyZoom.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DreamyZoom.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;
uniform float ratio;        // viewport aspect; set by the transition-base machinery

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

#define DEG2RAD 0.03926990816987241548078304229099 // 1/180*PI

uniform float rotation;     // knob; default in scr_transition_defaults
uniform float scale;        // knob; default in scr_transition_defaults

vec4 transition(vec2 uv) {
  float rot = rotation;
  float scl = scale;
  float r   = (ratio == 0.0)    ? 1.0 : ratio;

  // Massage parameters
  float phase = progress < 0.5 ? progress * 2.0 : (progress - 0.5) * 2.0;
  float angleOffset = progress < 0.5 ? mix(0.0, rot * DEG2RAD, phase) : mix(-rot * DEG2RAD, 0.0, phase);
  float newScale = progress < 0.5 ? mix(1.0, scl, phase) : mix(scl, 1.0, phase);

  vec2 center = vec2(0.0, 0.0);

  // Calculate the source point
  vec2 p = (uv.xy - vec2(0.5, 0.5)) / newScale * vec2(r, 1.0);

  float angle = atan(p.y, p.x) + angleOffset;
  float dist = distance(center, p);
  p.x = cos(angle) * dist / r + 0.5;
  p.y = sin(angle) * dist + 0.5;
  vec4 c = progress < 0.5 ? getFromColor(p) : getToColor(p);

  // Finally, apply the color
  return c + (progress < 0.5 ? mix(0.0, 1.0, phase) : mix(1.0, 0.0, phase));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
