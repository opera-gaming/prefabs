#version 300 es
in vec3 in_Position;
in vec4 in_Colour;
in vec2 in_TextureCoord;

out vec2 v_vTexcoord;
out vec4 v_vColour;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
