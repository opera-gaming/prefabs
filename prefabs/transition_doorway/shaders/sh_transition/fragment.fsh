#version 300 es
precision highp float;

// sh_transition — effect: doorway.
// Adapted from gl-transitions `doorway.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/doorway.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float reflection;   // knob; default in scr_transition_defaults
uniform float perspective;  // knob; default in scr_transition_defaults
uniform float depth;        // knob; default in scr_transition_defaults

const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
const vec2 boundMin = vec2(0.0, 0.0);
const vec2 boundMax = vec2(1.0, 1.0);

bool inBounds (vec2 p) {
  return all(lessThan(boundMin, p)) && all(lessThan(p, boundMax));
}

vec2 project (vec2 p) {
  return p * vec2(1.0, -1.2) + vec2(0.0, -0.02);
}

vec4 bgColor (vec2 p, vec2 pto, float refl) {
  vec4 c = black;
  pto = project(pto);
  if (inBounds(pto)) {
    c += mix(black, getToColor(pto), refl * mix(1.0, 0.0, pto.y));
  }
  return c;
}

vec4 transition (vec2 p) {
  float refl  = reflection;
  float persp = perspective;
  float dpth  = depth;
  vec2 pfr = vec2(-1.), pto = vec2(-1.);
  float middleSlit = 2.0 * abs(p.x-0.5) - progress;
  if (middleSlit > 0.0) {
    pfr = p + (p.x > 0.5 ? -1.0 : 1.0) * vec2(0.5*progress, 0.0);
    float d = 1.0/(1.0+persp*progress*(1.0-middleSlit));
    pfr.y -= d/2.;
    pfr.y *= d;
    pfr.y += d/2.;
  }
  float size = mix(1.0, dpth, 1.-progress);
  pto = (p + vec2(-0.5, -0.5)) * vec2(size, size) + vec2(0.5, 0.5);
  if (inBounds(pfr)) {
    return getFromColor(pfr);
  }
  else if (inBounds(pto)) {
    return getToColor(pto);
  }
  else {
    return bgColor(p, pto, refl);
  }
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
