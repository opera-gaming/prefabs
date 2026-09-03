#version 300 es
// Silhouette-edge texels (alpha crosses 0.5 against a neighbour) become
// seeds: their own texture coordinate with alpha 1; -1 with alpha 0 elsewhere.
precision highp float;

in vec2 v_vTexcoord;
out vec4 frag_colour;

float alphaAt(vec2 p) { return texture(gm_BaseTexture, p).a; }

void main() {
    vec2 uv = v_vTexcoord;
    vec2 px = 1.0 / vec2(textureSize(gm_BaseTexture, 0));
    bool inside = alphaAt(uv) > 0.5;
    bool edge =
        (alphaAt(uv + vec2( px.x, 0)) > 0.5) != inside ||
        (alphaAt(uv + vec2(-px.x, 0)) > 0.5) != inside ||
        (alphaAt(uv + vec2(0,  px.y)) > 0.5) != inside ||
        (alphaAt(uv + vec2(0, -px.y)) > 0.5) != inside;
    frag_colour = edge ? vec4(uv, 0.0, 1.0) : vec4(-1.0, -1.0, 0.0, 0.0);
}
