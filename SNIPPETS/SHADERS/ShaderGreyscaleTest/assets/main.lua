local shader=Shader.new("vShader","fShader",0,
	{
	{name="vMatrix",type=Shader.CMATRIX,sys=Shader.SYS_WVP,vertex=true},
	{name="fColor",type=Shader.CFLOAT4,sys=Shader.SYS_COLOR,vertex=false},
	{name="fTexture",type=Shader.CTEXTURE,vertex=false},
	},
	{
	{name="vVertex",type=Shader.DFLOAT,mult=3,slot=0,offset=0},
	{name="vColor",type=Shader.DUBYTE,mult=4,slot=1,offset=0},
	{name="vTexCoord",type=Shader.DFLOAT,mult=2,slot=2,offset=0},
	}
)

application:setBackgroundColor(0x333333)

local bitmap = Bitmap.new(Texture.new("test.png"))
local bitmap2 = Bitmap.new(Texture.new("arrow_0001.png"))
-- position
bitmap:setPosition(32*1, 32*1)
bitmap2:setPosition(32*5, 32*1)
-- shaders
bitmap:setShader(shader)
bitmap2:setShader(shader)
-- order
stage:addChild(bitmap)
stage:addChild(bitmap2)
