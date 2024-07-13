shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform sampler2D normalmap;

uniform vec2 wave_direction = vec2(2.0,0.0);
uniform vec2 wave_direction2 = vec2(0.0,1.0);
uniform vec2 wave_scale = vec2(2.0,2.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.1;

uniform float refraction_strength : hint_range(0.0, 8.0, 0.001) = 0.5;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;

uniform vec4 color_deep : source_color;
uniform vec4 color_shallow : source_color;
uniform float depth_scale = 0.3;
uniform float depth_offset = -0.5;

vec2 refract_uv(vec2 uv, float strength, vec3 normal)
{
	float strength1 = strength * pow(uv.y, 4.0);
	uv += strength1 * length(normal) - strength1 * 1.2;
	return uv;
}

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

vec3 unpackNormal(vec3 packedNormal)
{
	vec3 normal = packedNormal * 2.0 - 1.0;
    normal.z = sqrt(1.0 - normal.x*normal.x - normal.y * normal.y);
    return normal;
}

vec3 fragNormal(vec3 normal_map, vec3 normal, vec3 tangent, vec3 binormal)
{
	vec3 relNormal = normal_map.x * tangent;
	relNormal += normal_map.y * binormal;
	relNormal += normal_map.z * normal;
	return relNormal;
}

void fragment()
{
	float depth_texture = texture(DEPTH_TEXTURE, SCREEN_UV).r * 2.0 - 1.0;
	float depth = PROJECTION_MATRIX[3][2] / (depth_texture + PROJECTION_MATRIX[2][2]);
	float depth_blend = exp((depth+VERTEX.z + depth_offset) * -depth_scale);
	depth_blend = clamp(1.0 - depth_blend, 0.0, 1.0);
	float depth_blend_power = clamp(pow(depth_blend, 2.5), 0.0, 1.0);

	// Retrieving depth color and applying the deep and shallow colors
	vec3 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, depth_blend_power * 2.5).rgb;
	vec3 depth_color = mix(color_shallow.rgb, color_deep.rgb, depth_blend_power);
	vec3 color = mix(screen_color * depth_color, depth_color * 0.25, depth_blend_power * 0.5);

	vec2 time = (TIME * wave_direction) * time_scale;
	vec2 time2 = (TIME * wave_direction2) * time_scale;

	// Blend normal maps into one
	vec3 norm1 = fragNormal(unpackNormal(texture(normalmap,UV * wave_scale + time).rgb), NORMAL, TANGENT, BINORMAL);
	vec3 norm2 = fragNormal(unpackNormal(texture(normalmap,UV * wave_scale + time2).rgb), NORMAL, TANGENT, BINORMAL);
	vec3 normal_blend = norm1 + norm2;

	// Calculate Fresnel
	float fresnel = fresnel(4.0, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo2, fresnel); // Interpolate albedo values by frensel

	NORMAL = normal_blend;
	ALPHA = .9;
	ALBEDO = clamp(surface_color + color,vec3(0.0),vec3(1.0));
	ROUGHNESS = 0.001;
	METALLIC = 0.;
}