surface_reset_target();
if (in_target) {
    shader_set(sh_transition);

    texture_set_stage(0, surface_get_texture(from_surface));
    texture_set_stage(1, surface_get_texture(to_surface));
    shader_set_uniform_f(u_progress, clamp(t / fade_length, 0, 1));

    for (var j = 0; j < array_length(uniforms); ++j) {
        var u = uniforms[j];
        switch (u[0]) {
            case 0: shader_set_uniform_i(u[1], u[2][0]); break;
            case 1: shader_set_uniform_f(u[1], u[2][0]); break;
            case 2: shader_set_uniform_f_array(u[1], u[2]); break;
        }
    }

    draw_primitive_begin(pr_trianglestrip);
    draw_vertex_texture(-1, -1, 0, 0);
    draw_vertex_texture( 1, -1, 1, 0);
    draw_vertex_texture(-1,  1, 0, 1);
    draw_vertex_texture( 1,  1, 1, 1);
    draw_primitive_end();

    shader_reset();
} else {
    // First transition frame: capture done, now switch to the target room so
    // the next frames render it into to_surface. Draw-time by design.
    in_target = true; //gmx-lint-ignore draw-event-mutation
    room_goto(target_room);
}
