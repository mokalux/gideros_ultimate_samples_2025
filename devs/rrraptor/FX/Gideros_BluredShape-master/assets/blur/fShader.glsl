uniform lowp vec4 fColor;
uniform lowp vec4 fColorMod;
uniform lowp sampler2D fTexture;
uniform int fRad;
uniform mediump vec4 fTexelSize;
varying mediump vec2 fTexCoord;

vec4 toGrayscale(in vec4 color)
{
	float average = (color.r + color.g + color.b) / 3.0;
	return vec4(average, average, average, 1.0);
}

vec4 colorize(in vec4 grayscale, in vec4 color)
{
	return (grayscale * color);
}

void main() {
	lowp vec4 frag=vec4(0,0,0,0);
	int ext=2*fRad+1;	
	mediump vec2 tc=fTexCoord-fTexelSize.xy*float(fRad);
	for (int v=0;v<20;v++)	
	{
		if (v<ext)
			frag=frag+texture2D(fTexture, tc);
		tc+=fTexelSize.xy;
	}
	frag=frag/float(ext);
	if (frag.a==0.0) discard;
	vec4 grayscale = toGrayscale(frag);
	vec4 colored = colorize(grayscale, fColorMod);
	gl_FragColor = frag;
	//gl_FragColor = colored;
}
