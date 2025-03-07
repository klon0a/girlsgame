shader_type canvas_item;
uniform vec2 offset_amp = vec2(0.05);
uniform sampler2D noise_texture;
uniform float fps = 12.0;
uniform vec2 tex_scale = vec2(3.0);

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment(){
	float quant_time = round(TIME * fps);
	vec2 texture_off = vec2(random(vec2(0.0, quant_time)), random(vec2(quant_time,0.0)));
	vec2 noise_coord = (SCREEN_UV + texture_off) * tex_scale;
	noise_coord.x = mod(noise_coord.x, 1.0);
	noise_coord.y = mod(noise_coord.y, 1.0);
	vec2 random_off = texture(noise_texture, noise_coord).rg - vec2(0.5);
	COLOR = texture(TEXTURE, UV + random_off * offset_amp);
	//vec2 random_offset = random(vec2(0.0, TIME))
}