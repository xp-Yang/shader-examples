#include "../common.glsl"
#include "sdf_common.glsl"

float equilateralTriangleSDF(vec2 st, float sideLength)
{
    float r = sideLength / 2.0;
    st.x = abs(st.x);
    vec2 k = vec2(sqrt(3.0) / 2.0, -1.0 / 2.0);
    if (st.x * k.y - st.y * k.x < 0.0) {
        st = -st + 2.0 * (dot(st, k)) * k;
        //st = vec2(st.x - sqrt(3.0) * st.y, -sqrt(3.0) * st.x - st.y) / 2.0;
        st.x = abs(st.x);
    }
    if (st.x > r)
        return length(vec2(st.x - r, st.y + r / sqrt(3.0)));
    return -st.y - r / sqrt(3.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 st = normalizeST(fragCoord);
    float sdf = equilateralTriangleSDF(st, 0.5);
    fragColor = vec4(vec3(edge(sdf * 10.)), 1.0);
}