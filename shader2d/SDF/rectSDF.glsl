// uniform vec3      iResolution;           // viewport resolution (in pixels)
// uniform float     iTime;                 // shader playback time (in seconds)
// uniform float     iTimeDelta;            // render time (in seconds)
// uniform float     iFrameRate;            // shader frame rate
// uniform int       iFrame;                // shader playback frame
// uniform float     iChannelTime[4];       // channel playback time (in seconds)
// uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
// uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
// uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
// uniform vec4      iDate;                 // (year, month, day, time in seconds)

#include "../common.glsl"

float rectSDF(vec2 st, float width, float height) {
    st = abs(st);
    vec2 d = st - vec2(width, height);
    float outer = length(max(d, 0.0));
    float inner = max(d.x, d.y);
    return outer + min(inner, 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 st = normalizeST(fragCoord);
    float sdf = rectSDF(st, 0.5, 0.8);
    float f = fract(sdf * 30.0);
    float edge = smoothstep(0.25, 0.5, abs(f - 0.5));
    fragColor = vec4(vec3(edge), 1.0);
}