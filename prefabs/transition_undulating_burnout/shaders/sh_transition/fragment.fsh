#version 300 es
precision highp float;

// sh_transition — effect: undulating-burnout.
// Adapted from gl-transitions `undulatingBurnOut.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/undulatingBurnOut.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float smoothness;          // knob; default in scr_transition_defaults
const vec2 center = vec2(0.5);     // default center
const vec3 color  = vec3(0.0);     // default burn color

const float M_PI = 3.14159265358979323846;

float quadraticInOut(float t) {
  float p = 2.0 * t * t;
  return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float getGradient(float r, float dist) {
  float sm = smoothness;
  float d = r - dist;
  return mix(
    smoothstep(-sm, 0.0, r - dist * (1.0 + sm)),
    -1.0 - step(0.005, d),
    step(-0.005, d) * step(d, 0.01)
  );
}

float getWave(vec2 p){
  vec2 _p = p - center; // offset from center
  float rads = atan(_p.y, _p.x);
  float degs = degrees(rads) + 180.0;
  vec2 range = vec2(0.0, M_PI * 30.0);
  vec2 domain = vec2(0.0, 360.0);
  float ratio = (M_PI * 30.0) / 360.0;
  degs = degs * ratio;
  float x = progress;
  float magnitude = mix(0.02, 0.09, smoothstep(0.0, 1.0, x));
  float offset = mix(40.0, 30.0, smoothstep(0.0, 1.0, x));
  float ease_degs = quadraticInOut(sin(degs));
  float deg_wave_pos = (ease_degs * magnitude) * sin(x * offset);
  return x + deg_wave_pos;
}

vec4 transition(vec2 p) {
  float dist = distance(center, p);
  float m = getGradient(getWave(p), dist);
  vec4 cfrom = getFromColor(p);
  vec4 cto = getToColor(p);
  return mix(mix(cfrom, cto, m), mix(cfrom, vec4(color, 1.0), 0.75), step(m, -2.0));
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
