// https://godotshaders.com/shader/color-swap-with-hue-variation-preservation
shader_type canvas_item;

// How to use:
// 1) Store the initial color in `from`
// 2) Store the target color in `to`
// 3) Adjust tolerance to grab a range of hues or set to 0 for exact match

uniform vec4 from : source_color;
uniform vec4 to : source_color;
uniform float tolerance_hue: hint_range(0.0, 1.0);
uniform float tolerance_feather : hint_range(0.0, 1.0);

uniform sampler2D v_to_v_shift;
uniform sampler2D s_to_v_shift;
//uniform float contrast = 1.0;
//uniform float balance = 0.0;
uniform float greyscale_amount = 0.3;
uniform bool greyscale = false;


// Color space conversion from https://godotshaders.com/shader/color-range-swap/
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
float invLerp(float _from, float _to, float _value){
  return (_value - _from) / (_to - _from);
}

void fragment()
{
	// we usually want more granularity the closer we are to the original color
	float _tol = tolerance_hue * tolerance_hue;
	float _feath = tolerance_feather * tolerance_feather;
	
	vec4 tex = texture(TEXTURE, UV);
	vec3 source_hsv = rgb2hsv(tex.rgb);
	vec3 initial_hsv = rgb2hsv(from.rgb);
	vec3 hsv_shift = rgb2hsv(to.rgb) - initial_hsv;
	
	float hue = initial_hsv.r;
	
	// the .r here represents HUE, .g is SATURATION, .b is LUMINANCE
	float hue_distance = abs(hue - source_hsv.r);
	hue_distance = 1.0 - abs(2.0 * hue_distance - 1.0); // this is a formula for /\ 
	float mix_by = invLerp(_tol - _feath, _tol + _feath, hue_distance);
	mix_by = clamp(mix_by, 0.0, 1.0);
	
	
	//hsv_shift.b = hsv_shift.b * (1.0 - abs(1.0 - (source_hsv.b * 2.0)) );
	hsv_shift.b = hsv_shift.b * texture(v_to_v_shift, vec2(source_hsv.b * 0.5)).r * texture(s_to_v_shift, vec2(source_hsv.g)).r;
	//COLOR.rgb = vec3(abs(hue_distance));
	//if (hue - source_hsv.r >= -_tol && hue - source_hsv.r <= +_tol)
	//{
		vec3 final_hsv = source_hsv + hsv_shift;
		final_hsv.g = clamp(final_hsv.g, 0.0, 1.0);
		final_hsv.b = clamp(final_hsv.b, 0.0, 1.0);
		tex.rgb = mix(hsv2rgb(final_hsv), tex.rgb, mix_by);
	//}
	
	//tex.rgb = mix(vec3(0.5), tex.rgb + vec3(balance), contrast);
	float grey = tex.r * 0.3 + tex.g * 0.59 + tex.b * 0.11;
	tex.rgb = mix(tex.rgb, vec3(grey),  step(0.5, float(greyscale))* greyscale_amount);
	COLOR = tex;
	//COLOR.rgb = vec3(source_hsv.b * (1.0 - source_hsv.g));
}
