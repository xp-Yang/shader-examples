#include "../common.glsl"

vec2 grid(vec2 st, float count)
{
    st *= count;
    vec2 f = fract(st);
    vec2 saw = abs(f - 0.5);
    vec2 grid = smoothstep(vec2(0.5) - 1. * fwidth(st), vec2(0.5), saw);
    return grid;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 st = normalizeST(fragCoord);
    vec2 grid = grid(st, 5.0);
    fragColor = vec4(vec3(0.5) + vec3(1.0) * clamp(grid.x + grid.y, 0.0, 1.0), 1.0);
}