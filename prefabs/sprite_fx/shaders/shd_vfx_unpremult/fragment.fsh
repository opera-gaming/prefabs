#version 300 es
// The capture is premultiplied; subject shaders read straight alpha.
precision highp float;

in vec2 v_vTexcoord;
out vec4 frag_colour;

void main() {
    vec4 c = texture(gm_BaseTexture, v_vTexcoord);
    frag_colour = vec4(c.a > 0.0 ? c.rgb / c.a : vec3(0.0), c.a);
}
