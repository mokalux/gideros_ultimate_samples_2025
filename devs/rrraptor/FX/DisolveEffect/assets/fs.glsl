uniform lowp vec4 fColor;
uniform lowp sampler2D fMainTex;
uniform lowp float fDisolve;
uniform lowp float fNoiseScale;
uniform lowp float fDisolveStrokeWidth;
uniform lowp vec4 fDisolveColor;

varying mediump vec2 fTexCoord;

// Unity shader graph +

// Simple noise
float unity_noise_randomValue (vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233)))*43758.5453);
}

float unity_noise_interpolate (float a, float b, float t) {
    return (1.0-t)*a + (t*b);
}

float unity_valueNoise (vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    f = f * f * (3.0 - 2.0 * f);

    uv = abs(fract(uv) - 0.5);
    vec2 c0 = i + vec2(0.0, 0.0);
    vec2 c1 = i + vec2(1.0, 0.0);
    vec2 c2 = i + vec2(0.0, 1.0);
    vec2 c3 = i + vec2(1.0, 1.0);
    float r0 = unity_noise_randomValue(c0);
    float r1 = unity_noise_randomValue(c1);
    float r2 = unity_noise_randomValue(c2);
    float r3 = unity_noise_randomValue(c3);

    float bottomOfGrid = unity_noise_interpolate(r0, r1, f.x);
    float topOfGrid = unity_noise_interpolate(r2, r3, f.x);
    float t = unity_noise_interpolate(bottomOfGrid, topOfGrid, f.y);
    return t;
}

float Unity_SimpleNoise_float(vec2 UV, float Scale) {
    float t = 0.0;

    float freq = pow(2.0, float(0));
    float amp = pow(0.5, float(3-0));
    t += unity_valueNoise(vec2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

    freq = pow(2.0, float(1));
    amp = pow(0.5, float(3-1));
    t += unity_valueNoise(vec2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

    freq = pow(2.0, float(2));
    amp = pow(0.5, float(3-2));
    t += unity_valueNoise(vec2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;

    return t;
}

// 

// Unity shader graph -

void main() {
	lowp vec4 col = texture2D(fMainTex,fTexCoord);
	float noise = Unity_SimpleNoise_float(fTexCoord, fNoiseScale);
	
	float st = step(noise, fDisolve);
	float outLine = step(noise, fDisolve + fDisolveStrokeWidth) - st;
	vec4 outLineColor = outLine * fDisolveColor;
	lowp vec4 color2 = vec4(col.rgb, st * col.a) + outLineColor;
	col.a *= color2.a;
	gl_FragColor = vec4(color2.rgb*col.a,col.a);
}
