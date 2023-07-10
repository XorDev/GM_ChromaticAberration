///@desc Initialize uniforms

//Shader uniforms
u_vector = shader_get_uniform(shd_chromatic_aberration, "u_vector");
u_texel = shader_get_uniform(shd_chromatic_aberration, "u_texel");

//Draw application surface with shader
application_surface_draw_enable(false);