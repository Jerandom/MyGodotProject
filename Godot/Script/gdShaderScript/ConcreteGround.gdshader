shader_type spatial;

// Texture maps
uniform sampler2D albedo_map;
uniform sampler2D normal_map;
uniform sampler2D bump_map;
uniform sampler2D ao_map;
uniform sampler2D roughness_map;
uniform sampler2D displacement_map;
uniform sampler2D reflection_map;
uniform float displacement_amount;

void vertex() {
    vec4 displacement = texture(displacement_map, UV);
    VERTEX += NORMAL * displacement.r * displacement_amount;
}

void fragment() {
    // Albedo (color) map
    vec3 albedo = texture(albedo_map, UV).rgb;

    // Normal map
    vec3 normal = texture(normal_map, UV).rgb * 2.0 - 1.0;

    // Bump map (converted to a normal map-like effect)
    vec3 bump = texture(bump_map, UV).rgb * 2.0 - 1.0;
    normal = normalize(normal + bump);

    // Ambient Occlusion map
    float ao = texture(ao_map, UV).r;

    // Roughness map
    float roughness = texture(roughness_map, UV).r;

    // Reflection map (used to affect metallic or reflective properties)
    float reflection = texture(reflection_map, UV).r;

    // Setting the normal
    NORMAL = normalize(normal);

    // Outputting the final color properties
    ALBEDO = albedo;
    ROUGHNESS = roughness;
    AO = ao;
    METALLIC = reflection;
}
