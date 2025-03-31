#include "../common.glsl"
#include "noise_common.glsl"

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 st = normalizeST(fragCoord);
    st *= 3.;
    vec2 i = floor(st);
    vec2 f = fract(st);

    float min_dist = 9.;

    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 neighbor = vec2(float(x),float(y));
            vec2 point = random2(i + neighbor);
            //point = 0.5 + 0.5*sin(iTime + 6.2831*point);
            min_dist = min(min_dist, length(neighbor + point - f));
        }
    }

    vec3 color = vec3(min_dist);
    color += 1.-step(.02, min_dist);

    fragColor = vec4(color, 1.0);
}