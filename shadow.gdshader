shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform vec4 mult_color : source_color;
uniform float lod;
uniform float lod2;

void fragment()
{
	vec4 bg_color = texture( SCREEN_TEXTURE, SCREEN_UV);
	float alpha = textureLod(TEXTURE, UV, lod).a;
	alpha = mix(alpha, textureLod(TEXTURE, UV, lod2).a, 0.5);
	//COLOR.rgb = bg_color.rgb * mult_color.rgb;
	COLOR.rgb = mult_color.rgb;
	COLOR.a = alpha * mult_color.a;
}