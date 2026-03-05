shader_type canvas_item;

// Texture de l'écran (automatique dans Godot 4 pour les CanvasItem)
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Paramètres de l'effet
uniform float blur_power : hint_range(0.0, 1.0) = 0.01;      // Force du flou
uniform float chromatic_power : hint_range(0.0, 1.0) = 0.02; // Séparation des couleurs
uniform vec2 center = vec2(0.5, 0.5);                        // Centre de l'effet (0.5, 0.5 = milieu de l'écran)
uniform int samples = 20;                                     // Qualité du flou (plus c'est haut, plus c'est lent)

void fragment() {
    // Vecteur allant du centre vers le pixel actuel
    vec2 direction = SCREEN_UV - center;
    float dist = length(direction);
    
    // Plus on est loin du centre, plus l'effet est fort
    float factor = dist * blur_power;
    
    vec3 final_color = vec3(0.0);
    
    // --- 1. Radial Blur ---
    // On échantillonne plusieurs fois la texture de l'écran le long de la direction
    for(int i = 0; i < samples; i++) {
        float scale = 1.0 - factor * (float(i) / float(samples - 1));
        
        // --- 2. Chromatic Aberration ---
        // On décale légèrement les coordonnées de lecture pour R, G, et B
        vec2 uv_r = center + direction * scale * (1.0 + chromatic_power * dist);
        vec2 uv_g = center + direction * scale;
        vec2 uv_b = center + direction * scale * (1.0 - chromatic_power * dist);
        
        float r = texture(screen_texture, uv_r).r;
        float g = texture(screen_texture, uv_g).g;
        float b = texture(screen_texture, uv_b).b;
        
        final_color += vec3(r, g, b);
    }
    
    // Moyenne des échantillons
    final_color /= float(samples);
    
    COLOR = vec4(final_color, 1.0);
}