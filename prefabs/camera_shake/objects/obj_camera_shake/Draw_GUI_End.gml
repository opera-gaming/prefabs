if (surface != -1) {
    surface_reset_target();

    shader_set(shdr_camera_shake);

    texture_set_stage(0, surface_get_texture(surface));
    shader_set_uniform_i(texture, 0);
    shader_set_uniform_f(progress, clamp(t / shake_length, 0, 1));
    shader_set_uniform_f(magnitude, shake_mag[0], shake_mag[1], shake_mag[2]);

    draw_primitive_begin(pr_trianglestrip);
    draw_vertex_texture(-1, -1, 0, 0);
    draw_vertex_texture(1, -1, 1, 0);
    draw_vertex_texture(-1, 1, 0, 1);
    draw_vertex_texture(1, 1, 1, 1);
    draw_primitive_end();

    shader_reset();
}
