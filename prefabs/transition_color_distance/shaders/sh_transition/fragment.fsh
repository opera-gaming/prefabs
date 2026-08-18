#version 300 es
precision highp float;

// sh_transition — effect: color-distance.
// Adapted from gl-transitions `ColourDistance.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColourDistance.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

uniform float power;   // knob; default in scr_transition_defaults

vec4 transition(vec2 p) {
    float pw = power;
    vec4 fTex = getFromColor(p);
    vec4 tTex = getToColor(p);
    float m = step(distance(fTex, tTex), progress);
    return mix(
        mix(fTex, tTex, m),
        tTex,
        pow(progress, pw)
    );
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
