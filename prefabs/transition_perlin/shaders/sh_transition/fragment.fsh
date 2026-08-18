#version 300 es
precision highp float;

// sh_transition — effect: perlin.
// Adapted from gl-transitions `perlin.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/perlin.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float scale;       // knob; default in scr_transition_defaults
uniform float smoothness;  // knob; default in scr_transition_defaults
uniform float seed;        // knob; default in scr_transition_defaults

// http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/
float random(vec2 co)
{
    highp float a = seed;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);

    // Mix 4 corners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

vec4 transition (vec2 uv) {
  float sc = scale;
  float sm = smoothness;
  vec4 from = getFromColor(uv);
  vec4 to = getToColor(uv);
  float n = noise(uv * sc);

  float p = mix(-sm, 1.0 + sm, progress);
  float lower = p - sm;
  float higher = p + sm;

  float q = smoothstep(lower, higher, n);

  return mix(
    from,
    to,
    1.0 - q
  );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
