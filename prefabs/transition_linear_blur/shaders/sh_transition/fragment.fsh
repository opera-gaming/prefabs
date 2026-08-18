#version 300 es
precision highp float;

// sh_transition — effect: linear-blur.
// Adapted from gl-transitions `LinearBlur.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LinearBlur.glsl
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
const int passes = 6;

vec4 transition(vec2 uv) {
    float amt = intensity;
    vec4 c1 = vec4(0.0);
    vec4 c2 = vec4(0.0);

    float disp = amt*(0.5-distance(0.5, progress));
    for (int xi=0; xi<passes; xi++)
    {
        float x = float(xi) / float(passes) - 0.5;
        for (int yi=0; yi<passes; yi++)
        {
            float y = float(yi) / float(passes) - 0.5;
            vec2 v = vec2(x,y);
            float d = disp;
            c1 += getFromColor( uv + d*v);
            c2 += getToColor( uv + d*v);
        }
    }
    c1 /= float(passes*passes);
    c2 /= float(passes*passes);
    return mix(c1, c2, progress);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
