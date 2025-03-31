float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float valueNoise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(mix(a, b, u.x),
    			mix(c, d, u.x), u.y);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float gradientNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

	vec2 a = random2(i + vec2(0.0,0.0));
	vec2 b = random2(i + vec2(1.0,0.0));
	vec2 c = random2(i + vec2(0.0,1.0));
	vec2 d = random2(i + vec2(1.0,1.0));
	
	float dot_a = dot( a, f - vec2(0.0,0.0) );
	float dot_b = dot( b, f - vec2(1.0,0.0) );
	float dot_c = dot( c, f - vec2(0.0,1.0) );
	float dot_d = dot( d, f - vec2(1.0,1.0) );
	
    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot_a, dot_b, u.x),
                mix( dot_c, dot_d, u.x), u.y) * 0.5 + 0.5;
}

mat3 rotate2d(float angle) {
	return mat3(cos(angle), sin(angle), 0,
				-sin(angle), cos(angle), 0,
				0, 0, 1);
}

mat3 translate2d(vec2 offset) {
	return mat3(1, 0, 0,
				0, 1, 0,
				offset.x, offset.y, 1);
}