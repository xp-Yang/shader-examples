#include "../common.glsl"

float segmentSDF(vec2 st, vec2 a, vec2 b)
{
    float c = clamp(dot((st - a), (b - a)) / dot(b - a, b - a), 0.0, 1.0);
    vec2 distance = (st - a) - c * (b - a);
    return length(distance);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 st = normalizeST(fragCoord);
    float sdf = segmentSDF(st, vec2(-0.5, -0.5), vec2(0.5, 0.8));
    fragColor = vec4(vec3(sdf), 1.0);
}