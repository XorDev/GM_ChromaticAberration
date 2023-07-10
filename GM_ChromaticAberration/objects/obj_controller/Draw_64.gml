///@desc Draw with chromatic aberration

//Chromatic aberration vector
var _mx,_my;
_mx = mouse_x/room_width*2-1;
_my = mouse_y/room_height*2-1;

//Texel size
var _tex,_texel_w,_texel_h;
_tex = surface_get_texture(application_surface);
_texel_w = texture_get_texel_width(_tex);
_texel_h = texture_get_texel_height(_tex);

//Apply shader
shader_set(shd_chromatic_aberration);
shader_set_uniform_f(u_vector,_mx,_my);
shader_set_uniform_f(u_texel,_texel_w,_texel_h);

draw_surface(application_surface,0,0);
shader_reset();