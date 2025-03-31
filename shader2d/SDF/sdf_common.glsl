float edge(float st)
{
    return smoothstep(0.5 - fwidth(st), 0.5, abs(fract(st) - 0.5));
}

vec2 edge(vec2 st)
{
    return smoothstep(vec2(0.5) - fwidth(st), vec2(0.5), abs(fract(st) - 0.5));
}