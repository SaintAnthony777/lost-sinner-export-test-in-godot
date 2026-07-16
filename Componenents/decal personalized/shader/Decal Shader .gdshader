shader_type spatial;
render_mode world_vertex_coords, blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform vec2 Scale = vec2(1.000000, 1.000000);
uniform sampler2D Albedo : source_color, repeat_disable;
uniform sampler2D Normal : source_color, hint_normal, repeat_disable;
uniform sampler2D Roughtness : source_color, hint_default_white, repeat_disable;
uniform sampler2D Emission : source_color, hint_default_black, repeat_disable;
uniform float Albedo_Mix : hint_range(0.0, 1.1, 0.1) = 1.1;

uniform float Emission_Energy : hint_range(0.0, 30, 0.1) = 1.0;
uniform vec4 Modulate : source_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 Modulate_Emission : source_color = vec4(1.0,1.0,1.0,1.0);

uniform sampler2D DEPTH_TEXTURE: hint_depth_texture;
uniform float cube_half_size = 0.5;

// Y-axis fade controls
uniform bool enable_y_fade = false; // Toggle for fade effect
uniform float fade_start = 0.3; // Where fading begins (0-1)
uniform float fade_end = 0.7;   // Where fading ends (0-1)
uniform float fade_power = 2.0; // Curve sharpness

varying mat4 INV_MODEL_MATRIX;

void vertex(){
    INV_MODEL_MATRIX = inverse(MODEL_MATRIX);
}

vec3 world_pos_from_depth(float depth, vec2 screen_uv, mat4 inverse_proj, mat4 inverse_view) {
    float z = depth;
    vec4 clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, z, 1.0);
    vec4 viewSpacePosition = inverse_proj * clipSpacePosition;
    viewSpacePosition /= viewSpacePosition.w;
    vec4 worldSpacePosition = inverse_view * viewSpacePosition;
    return worldSpacePosition.xyz;
}

float smooth_fade(float y_pos) {
    // Normalize Y position (-0.5 to 0.5) -> (0 to 1)
    float normalized_y = clamp((y_pos + cube_half_size) / (2.0 * cube_half_size), 0.0, 1.0);
    
    // Calculate fade factor
    float fade_factor = smoothstep(fade_start, fade_end, normalized_y);
    fade_factor = pow(fade_factor, fade_power);
    
    return 1.0 - fade_factor;
}

void fragment() {
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
    vec3 world_pos = world_pos_from_depth(depth, SCREEN_UV, INV_PROJECTION_MATRIX, (INV_VIEW_MATRIX));
    vec4 test_pos = (INV_MODEL_MATRIX * vec4(world_pos, 1.0));
    
    if (abs(test_pos.x) > cube_half_size || abs(test_pos.y) > cube_half_size || abs(test_pos.z) > cube_half_size) {
        discard;
    }

    vec2 NEW_UV = (test_pos.xz) + 0.5;
    
    vec4 n_out3p0 = texture(Albedo, NEW_UV * Scale);
    vec3 emission_map = texture(Emission, NEW_UV * Scale).rgb;
    vec3 normal_map = texture(Normal, NEW_UV * Scale).rgb;
    float rought_map = texture(Roughtness, NEW_UV * Scale).r;

    // Default fade factor (1.0 means no fade)
    float y_fade = 1.0;
    
    // Only calculate fade if enabled
    if (enable_y_fade) {
        y_fade = smooth_fade(test_pos.y);
        if (y_fade <= 0.0) {
            discard;
        }
    }

    // Apply fade to all channels (or full strength if fade disabled)
    ALBEDO = n_out3p0.rgb * Modulate.rgb * y_fade;
    ALPHA = n_out3p0.a * Albedo_Mix * Modulate.a * y_fade;
    NORMAL = normal_map;
    EMISSION = emission_map * Emission_Energy * Modulate_Emission.rgb * y_fade;
    ROUGHNESS = rought_map;
}

// Credits: Shader based on OlisUnfinishedProjects 4.0 Decal Shader 
// https://godotshaders.com/shader/decal-shader-4-0-port/
// https://stackoverflow.com/questions/32227283/getting-world-position-from-depth-buffer-value