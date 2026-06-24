shader_type spatial;

// Rendu additif et sans ombres pour de la pure lumière électrique
render_mode blend_add, unshaded, cull_disabled;

// Uniforms pour l'inspecteur 3D
uniform vec4 lightning_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float speed = 2.0;
uniform float line_thickness = 0.08;
uniform float hdr_intensity : hint_range(1.0, 20.0) = 5.0; 
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
// --- FONCTIONS DE NOISE MATHÉMATIQUES ---
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fractal_noise(vec2 uv) {
    float n = 0.0;
    n += 0.500 * noise(uv);
    uv *= 2.02;
    n += 0.250 * noise(uv);
    uv *= 2.03;
    n += 0.125 * noise(uv);
    return n;
}

// --- CŒUR DU SHADER 3D ---
void fragment() {
    // 1. En 3D, on utilise toujours "UV", mais appliqué sur les coordonnées de ton Mesh
    vec2 uv = UV * 2.0 - 1.0;
    
    // Deformer l'axe X avec le bruit temporel pour créer les zig-zags de l'éclair
    uv.x += (fractal_noise(vec2(uv.y * 2.0, TIME * speed)) - 0.5) * 0.5;
    
    // 2. Calcul de la distance au centre de l'éclair
    float dist = abs(uv.x);
    
    // 3. Masque de découpe de l'éclair (0 aux bords, 1 au centre de la ligne)
    float mask = 1.0 - smoothstep(0.0, line_thickness, dist);
    
    // 4. Couleur finale avec surpuissance lumineuse (Glow HDR)
    vec3 final_glow = lightning_color.rgb * hdr_intensity;
    
    // 5. ASSIGNATION AUX CANAUX 3D
    ALBEDO = final_glow;             // La couleur de base visible
    EMISSION = final_glow;           // Indispensable en 3D pour faire réagir le Glow du WorldEnvironment
    ALPHA = mask;                    // Découpe la forme de l'éclair sur le mesh transparent
}
void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;

	// Billboard Mode: Enabled
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			MAIN_CAM_INV_VIEW_MATRIX[0],
			MAIN_CAM_INV_VIEW_MATRIX[1],
			MAIN_CAM_INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}