//precision highp float;
#ifdef GLES2
	precision highp float;
#endif
uniform lowp vec4 fColor;
uniform lowp sampler2D fTexture;
varying mediump vec2 fTexCoord;
 
void main() {
	lowp vec4 frag = fColor*texture2D(fTexture, fTexCoord);
	if (frag.a == 0.0) discard;
	float gray = dot(frag.rgb, vec3(0.299, 0.587, 0.114));
	gl_FragColor = vec4(gray, gray, gray,frag.a);
}
