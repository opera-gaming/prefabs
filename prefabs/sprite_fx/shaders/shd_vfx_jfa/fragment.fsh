#version 300 es
// One jump-flood step: each texel adopts the nearest seed among its 3×3
// neighbours at stride uStep.
precision highp float;

in vec2 v_vTexcoord;
out vec4 frag_colour;

uniform float uStep;

void main() {
    vec2 uv = v_vTexcoord;
    vec2 px = 1.0 / vec2(textureSize(gm_BaseTexture, 0));
    vec4 best = vec4(-1.0, -1.0, 0.0, 0.0);
    float bd = 1e9;
    for (int y = -1; y <= 1; y++)
    for (int x = -1; x <= 1; x++) {
        vec4 s = texture(gm_BaseTexture, uv + vec2(float(x), float(y)) * uStep * px);
        if (s.a < 0.5) continue;
        float d = distance(s.xy, uv);
        if (d < bd) { bd = d; best = s; }
    }
    frag_colour = best;
}
