shader_type spatial;
render_mode diffuse_lambert,specular_toon,cull_disabled;
uniform vec3 albedo_perso:source_color;
uniform vec3 albedo_perso2:source_color;
uniform float roughness_perso:hint_range(0.0,1.0)=0;
uniform float metallic_perso:hint_range(0.0,1.0)=0.02;
uniform sampler2D wave;
uniform sampler2D texture_normal_1;
uniform sampler2D texture_normal_2;
uniform vec2 direction_des_vagues_1=vec2(2.0,0.0);
uniform vec2 direction_des_vagues_2=vec2(0.0,1.0);
uniform float time_scale:hint_range(0.0, 0.2, 0.005)=0.025;
uniform float noise_scale=10.0;
uniform float height_scale=0.15;
uniform sampler2D DEPTH_TEXTURE:hint_depth_texture,filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture,filter_linear_mipmap;

//depth
uniform vec4 color_deep:source_color;
uniform vec4 color_shallow:source_color;
uniform float beers_law=2.0;
uniform float depth_offset=-0.75;

//Edges here!!!!!
uniform float edge_scale=0.1;
uniform float near =1.0;
uniform float far=100.0;
uniform vec3 edge_color:source_color;

//Varying variables
varying float height;
varying vec3 world_position;

//fresnel effects for the water distance view
float fresnel(float amount, vec3 normal,vec3 view){
	return pow((1.0-clamp(dot(normalize(normal),normalize(view)),0.0,1.0)),amount);
}
//edges effect_here!!!
float edge(float depth){
	depth=2.0 * depth - 1.0;
	return near * far / (far + depth * (near-far));
}

void vertex() {
	world_position=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
	height=texture(wave,world_position.xz/noise_scale+TIME*time_scale).r;
	VERTEX.y+=height*height_scale;
}
void fragment() {
	//depth
	float depth_texture=texture(DEPTH_TEXTURE,SCREEN_UV).r*2.0-1.0;
	float depth =PROJECTION_MATRIX[3][2]/(depth_texture+PROJECTION_MATRIX[2][2]);
	float depth_blend =exp((depth+VERTEX.z+depth_offset)*-beers_law);
	depth_blend=clamp(1.0-depth_blend,0.0,1.0);
	float depth_blend_power=clamp(pow(depth_blend,2.5),0.0,1.0);

	vec3 screen_color=textureLod(SCREEN_TEXTURE,SCREEN_UV,depth_blend_power*2.5).rgb;
	vec3 depth_color=mix(color_shallow.rgb,color_deep.rgb,depth_blend_power);
	vec3 color =mix(screen_color*depth_color,depth_color*0.25,depth_blend_power*0.5);


	//obtention des edges scales
	float z_depth=edge(texture(DEPTH_TEXTURE,SCREEN_UV).x);
	float z_pos=edge(FRAGCOORD.z);
	float z_dif = z_depth - z_pos;

	//calcul du temps pour les vagues
	vec2 time1=(TIME*direction_des_vagues_1)*time_scale;
	vec2 time2=(TIME*direction_des_vagues_2)*time_scale;

	//mix des normal maps pour les formes
	vec3 normal=mix(texture(texture_normal_1,world_position.xz + time1).rgb,texture(texture_normal_2,world_position.xz +time2).rgb,0.5);
	//fresnel effect here!!!
	float fresnel =fresnel(5.0,NORMAL,VIEW);
	vec3 surface_color=mix(albedo_perso,albedo_perso2,fresnel*1.2);

	vec3 depth_color_adj=mix(edge_color,color,step(edge_scale,z_dif));
	//ALBEDO=surface_color;
	//ALBEDO=mix(surface_color,color,0.75);
	ALBEDO=mix(surface_color,depth_color_adj,0.05);
	ROUGHNESS=roughness_perso;
	METALLIC=metallic_perso;
	NORMAL_MAP=normal;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
