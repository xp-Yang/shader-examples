#include "../common.glsl"
#include "noise_common.glsl"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 st = normalizeST(fragCoord);
    st *= 5.;
    vec2 i = floor(st);
    vec2 f = fract(st);

    float min_dist = 9.;
    vec2 closest_point;
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 cell = i + vec2(float(x), float(y));
            vec2 point = random2(cell);
            point = 0.5 + 0.5 * sin(iTime + 6.2831 * point);
            float dist = length(cell + point - st);
            if(min_dist > dist) {
                min_dist = dist;
                closest_point = cell + point;
            }
        }
    }

    float min_edge_dist = 9.;
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 cell = i + vec2(float(x), float(y));
            vec2 point = random2(cell);
            point = 0.5 + 0.5 * sin(iTime + 6.2831 * point);
            float dist = length(cell + point - st);
            if(abs(dist - min_dist) < 0.0001)
                continue;
            vec2 to_point = cell + point - st;
            vec2 to_closest_point = closest_point - st;
            float edgeDist = dot((to_point + to_closest_point) / 2.0, normalize(to_point - to_closest_point));
            if(min_edge_dist > edgeDist)
                min_edge_dist = edgeDist;
        }
    }

    vec3 cell_color = vec3(valueNoise(closest_point / 5.),
      valueNoise((closest_point + vec2(2., 2.)) / 5.),
      valueNoise((closest_point - vec2(2., 2.)) / 5.));
    float border = (1. - smoothstep(0.02 - length(fwidth(st)), 0.02 + length(fwidth(st)), min_edge_dist));
    vec3 color = (1. - border) * cell_color + border * vec3(0.0);

    //color += 1. - step(.02, min_dist);

    fragColor = vec4(color, 1.0);
}