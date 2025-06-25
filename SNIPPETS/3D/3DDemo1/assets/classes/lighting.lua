Lighting={}

local LightingVShader=
[[
attribute vec4 POSITION0;
#ifdef TEXTURED
attribute vec2 TEXCOORD0;
#endif
attribute vec3 NORMAL0;

uniform mat4 g_MVPMatrix;
uniform mat4 g_MVMatrix;
uniform mat4 g_NMatrix;

varying highp vec3 position;
#ifdef TEXTURED
varying mediump vec2 texCoord;
#endif
varying mediump vec3 normalCoord;

void main()
{
#ifdef TEXTURED
	texCoord = TEXCOORD0;
#endif
	position = (g_MVMatrix*vec4(POSITION0.xyz,1)).xyz;
	normalCoord = normalize((g_NMatrix*vec4(NORMAL0.xyz,0)).xyz);
	gl_Position = g_MVPMatrix * POSITION0;
}
]]

local LightingFShader=[[
#extension GL_OES_standard_derivatives : enable
uniform lowp vec4 g_Color;
uniform highp vec4 lightPos;
uniform lowp float ambient;
uniform mediump vec4 specCol;
#ifdef TEXTURED
uniform lowp sampler2D g_Texture;
#endif
#ifdef NORMMAP
uniform lowp sampler2D g_NormalMap;
#endif

#ifdef TEXTURED
varying mediump vec2 texCoord;
#endif
varying mediump vec3 normalCoord;
varying highp vec3 position;

#ifdef GLES2
precision highp float;
#endif

#ifdef NORMMAP
mat3 cotangent_frame(vec3 N, vec3 p, vec2 uv)
{
    // récupère les vecteurs du triangle composant le pixel
    highp vec3 dp1 = dFdx( p );
    highp vec3 dp2 = dFdy( p );
    highp vec2 duv1 = dFdx( uv );
    highp vec2 duv2 = dFdy( uv );

    // résout le système linéaire
    highp vec3 dp2perp = cross( dp2, N );
    highp vec3 dp1perp = cross( N, dp1 );
    highp vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    highp vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;

    // construit une trame invariante à l'échelle 
    highp float invmax = inversesqrt( max( dot(T,T), dot(B,B) ) );
    return mat3( T * invmax, B * invmax, N );
}

vec3 perturb_normal( vec3 N, vec3 V, vec2 texcoord )
{
    // N, la normale interpolée et
    // V, le vecteur vue (vertex dirigé vers l'œil)
    vec3 map = texture2D(g_NormalMap, texcoord ).xyz;
    map = map *255./127. - 128./127.;
    highp mat3 TBN = cotangent_frame(N, V*lightPos.w, texcoord);
    return normalize(TBN * map);
}
#endif

void main()
{
#ifdef TEXTURED
	lowp vec3 color0 = texture2D(g_Texture, texCoord).rgb;
#else
	lowp vec3 color0 = g_Color.xyz;
#endif
	highp vec3 normal = normalCoord;
	
	highp vec3 lightDir = normalize(lightPos.xyz - position.xyz);
	highp vec3 viewDir = normalize(-position.xyz);
#ifdef NORMMAP	
	normal=perturb_normal(normal, viewDir, texCoord);
#endif	
	
	mediump float diff = max(0.0, dot(normal, lightDir));
	mediump float spec =0.0;
	if (diff>0.0)
	{
		mediump float nh = max(0.0, dot(reflect(-lightDir,normal),viewDir));
		spec = pow(nh, specCol.w);
	}
	diff=max(diff,ambient);
	
	gl_FragColor = vec4(color0 * diff + specCol.xyz * spec, 1.0);
}
]]

local LightingShaderAttrs=
{
{name="POSITION0",type=Shader.DFLOAT,mult=3,slot=0,offset=0},
{name="vColor",type=Shader.DUBYTE,mult=0,slot=1,offset=0},
{name="TEXCOORD0",type=Shader.DFLOAT,mult=2,slot=2,offset=0},
{name="NORMAL0",type=Shader.DFLOAT,mult=3,slot=3,offset=0}
}

local LightingShaderConstants={
{name="g_MVPMatrix",type=Shader.CMATRIX,sys=Shader.SYS_WVP, vertex=true},
{name="g_MVMatrix",type=Shader.CMATRIX,sys=Shader.SYS_WORLD, vertex=true},
{name="g_NMatrix",type=Shader.CMATRIX,sys=Shader.SYS_WIT3, vertex=true},
{name="g_Color",type=Shader.CFLOAT4,mult=1,sys=Shader.SYS_COLOR},
{name="lightPos",type=Shader.CFLOAT4,mult=1,vertex=false},
{name="specCol",type=Shader.CFLOAT4,mult=1,vertex=false},
{name="ambient",type=Shader.CFLOAT,mult=1,vertex=false}}

-- Shaders defs
if application:getDeviceInfo()~="WinRT" then

Lighting.normal_shader_b = Shader.new(
LightingVShader,LightingFShader,
Shader.FLAG_FROM_CODE,LightingShaderConstants,LightingShaderAttrs)

LightingShaderConstants[#LightingShaderConstants+1]=
	{name="g_Texture",type=Shader.CTEXTURE,mult=1,vertex=false}

Lighting.normal_shader_t = Shader.new(
[[#define TEXTURED
]]..LightingVShader,
[[#define TEXTURED
]]..LightingFShader,
Shader.FLAG_FROM_CODE,LightingShaderConstants,LightingShaderAttrs)

LightingShaderConstants[#LightingShaderConstants+1]=
	{name="g_NormalMap",type=Shader.CTEXTURE,mult=1,vertex=false}

Lighting.normal_shader_tn = Shader.new(
[[#define TEXTURED
#define NORMMAP
]]..LightingVShader,
[[#define TEXTURED
#define NORMMAP
]]..LightingFShader,
Shader.FLAG_FROM_CODE,LightingShaderConstants,LightingShaderAttrs)

Lighting.allShaders={Lighting.normal_shader_t,Lighting.normal_shader_b,Lighting.normal_shader_tn}
else
Lighting.allShaders={}
end

function Lighting.setSpecular(r,g,b,shininess)
	for _,v in ipairs(Lighting.allShaders) do
	 v:setConstant("specCol",Shader.CFLOAT4,1,r,g,b,shininess)
	end
end
function Lighting.setLight(x,y,z,a,r)
	for _,v in ipairs(Lighting.allShaders) do
	 v:setConstant("lightPos",Shader.CFLOAT4,1,x,y,z,r or 1)
	 v:setConstant("ambient",Shader.CFLOAT,1,a)
	end
end

function Lighting.apply(m)
	if #Lighting.allShaders>0 and m:isInstanceOf("Sprite") then
		if m:isInstanceOf("Mesh") then
			if m.hasNormals then
				if (m.hasTexture) then				
					if m.hasNormalMap then
						m:setShader(Lighting.normal_shader_tn)			
					else
						m:setShader(Lighting.normal_shader_t)
					end
				else
					m:setShader(Lighting.normal_shader_b)
				end
			end
		end
		for i=1,m:getNumChildren() do
			Lighting.apply(m:getChildAt(i))
		end
	end
end

Lighting.setSpecular(0.1,0.1,0.1,32)
