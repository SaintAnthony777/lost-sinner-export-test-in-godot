shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);
uniform float force : hint_range(0.0, 1.0) = 0.05; // Puissance de la déformation
uniform float size : hint_range(0.0, 1.0) = 0.0;  // Rayon de l'onde
uniform float thickness : hint_range(0.0, 0.5) = 0.1; // Largeur de la bordure déformante

void fragment() {
    // Ratio pour garder le cercle rond (évite l'étirement sur les écrans larges)
    float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    vec2 scaled_uv = (SCREEN_UV - center) / vec2(ratio, 1.0) + center;
    
    float dist = distance(scaled_uv, center);
    
    // Création d'un masque en forme d'anneau (Smoothstep pour éviter les bords nets)
    float mask = smoothstep(size, size - thickness, dist) - 
                 smoothstep(size - thickness, size - thickness * 2.0, dist);
    
    // Calcul de la direction de la déformation (du centre vers l'extérieur)
    vec2 disp = normalize(SCREEN_UV - center) * force * mask;
    
    // Lecture de l'écran avec le décalage
    COLOR = texture(screen_texture, SCREEN_UV - disp);
}