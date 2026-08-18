var app = application_get_position();

t = 0;

surface = surface_create(app[2]-app[0], app[3]-app[1]);
progress = shader_get_uniform(shdr_camera_shake, "progress");
texture = shader_get_sampler_index(shdr_camera_shake, "tex");
magnitude = shader_get_uniform(shdr_camera_shake, "mag");
