#include "../common.glsl"

float circleSDF(vec2 st, float radius) {
    float length = length(st);
    return length - radius;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 st = normalizeST(fragCoord);
    float sdf = circleSDF(st, 0.5);
    fragColor = vec4(vec3(sdf), 1.0);
}