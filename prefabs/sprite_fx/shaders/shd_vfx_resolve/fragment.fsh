#version 300 es
// Flooded seeds to a distance, folded into last frame's field: old distances
// grow by uGrow and move by uDrift. Clamped to FAR texture units, which is
// also what a texel with no seed in reach reads.
precision highp float;

#define FAR 4.0

in vec2 v_vTexcoord;
out vec4 frag_colour;

uniform sampler2D uPrev;
uniform float uGrow;
uniform vec2 uDrift;

void main() {
    vec2 uv = v_vTexcoord;
    vec4 s = texture(gm_BaseTexture, uv);
    float dNow = s.a < 0.5 ? FAR : distance(uv, s.xy);
    float dOld = texture(uPrev, uv - uDrift).r + uGrow;
    frag_colour = vec4(min(min(dNow, dOld), FAR));
}
