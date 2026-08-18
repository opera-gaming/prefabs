#version 300 es
// Fullscreen pass-through: `in_Position` is already in clip space (the
// transition draws a -1..1 quad via draw_vertex_texture), so do NOT apply the
// GM matrix here.
in vec2 in_Position;
in vec2 in_TextureCoord;

out vec2 v_vTexcoord;

void main() {
    gl_Position = vec4(in_Position, 0.0, 1.0);
    v_vTexcoord = in_TextureCoord;
}
