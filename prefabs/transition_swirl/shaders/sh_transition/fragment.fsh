#version 300 es
precision highp float;

// sh_transition — effect: swirl.
// Adapted from gl-transitions `Swirl.glsl` (MIT):
//   https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Swirl.glsl
// Overrides transition-base's fragment shader; the vertex shader is inherited.
// Keep the V-flip in getFromColor/getToColor (matches the base contract).

uniform sampler2D from_tex;
uniform sampler2D to_tex;
uniform float progress;

in vec2 v_vTexcoord;
out vec4 frag_colour;

vec4 getToColor(vec2 uv)   { return texture(to_tex,   vec2(uv.x, 1.0 - uv.y)); }
vec4 getFromColor(vec2 uv) { return texture(from_tex, vec2(uv.x, 1.0 - uv.y)); }

vec4 transition(vec2 UV) {
    float Radius = 1.0;

    float T = progress;

    UV -= vec2(0.5, 0.5);

    float Dist = length(UV);

    if (Dist < Radius) {
        float Percent = (Radius - Dist) / Radius;
        float A = (T <= 0.5) ? mix(0.0, 1.0, T / 0.5) : mix(1.0, 0.0, (T - 0.5) / 0.5);
        float Theta = Percent * Percent * A * 8.0 * 3.14159;
        float S = sin(Theta);
        float C = cos(Theta);
        UV = vec2(dot(UV, vec2(C, -S)), dot(UV, vec2(S, C)));
    }
    UV += vec2(0.5, 0.5);

    vec4 C0 = getFromColor(UV);
    vec4 C1 = getToColor(UV);

    return mix(C0, C1, T);
}

void main() {
    frag_colour = transition(v_vTexcoord);
}
