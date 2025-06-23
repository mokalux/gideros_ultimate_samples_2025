application:setBackgroundColor(0xf4f4f4)

-- Shader setup
local color = {0,0,1,.5} -- outline color
local tex = Texture.new("logo.png", true)
-- Shader.new(vertex,fragment,flags,uniform descriptor,attribute descriptor)
local shader = Shader.new("vs", "fs", 0, 
	{
		{name="vMatrix",type=Shader.CMATRIX,sys=Shader.SYS_WVP,vertex=true},
		{name="fColor",type=Shader.CFLOAT4,sys=Shader.SYS_COLOR,vertex=false},
		{name="fMainTex",type=Shader.CTEXTURE,vertex=false},
		
		{name="fDisolve",type=Shader.CFLOAT,vertex=false},
		{name="fNoiseScale",type=Shader.CFLOAT,vertex=false},
		{name="fDisolveStrokeWidth",type=Shader.CFLOAT,vertex=false},
		{name="fDisolveColor",type=Shader.CFLOAT4,vertex=false},
	},
	{
		{name="vVertex",type=Shader.DFLOAT,mult=3,slot=0,offset=0},
		{name="vColor",type=Shader.DUBYTE,mult=4,slot=1,offset=0},
		{name="vTexCoord",type=Shader.DFLOAT,mult=2,slot=2,offset=0},
	}
)
local btm = Bitmap.new(tex)
shader:setConstant("fDisolve", Shader.CFLOAT, 1, 0.5)
shader:setConstant("fNoiseScale", Shader.CFLOAT, 1, 80.0)
shader:setConstant("fDisolveStrokeWidth", Shader.CFLOAT, 1, 0.1)
shader:setConstant("fDisolveColor", Shader.CFLOAT4, 1, color)
btm:setShader(shader)
stage:addChild(btm)
btm:setY(200)

function setOutlineColorR(r)
	color[1] = r / 255
	shader:setConstant("fDisolveColor", Shader.CFLOAT4, 1, color)
end

function setOutlineColorG(g)
	color[2] = g / 255
	shader:setConstant("fDisolveColor", Shader.CFLOAT4, 1, color)
end

function setOutlineColorB(b)
	color[3] = b / 255
	shader:setConstant("fDisolveColor", Shader.CFLOAT4, 1, color)
end

function setOutlineColorA(a)
	color[4] = a / 255
	shader:setConstant("fDisolveColor", Shader.CFLOAT4, 1, color)
end


-- UI setup
local ui = SUI.new("touch")
stage:addChild(ui)
local g = ui:hGroup(5, 10)
g:add(ui:hSlider(
	0, 255, color[1] * 255, false,
	{Pixel.new(0,1,100,20), Pixel.new(0xff0000,1,20,20)},
	function(obj, v)
		setOutlineColorR(v)
	end):addText("R"):setTextColor(0xffffff))
g:add(ui:hSlider(
	0, 255, color[2] * 255, false,
	{Pixel.new(0,1,100,20), Pixel.new(0x00ff00,1,20,20)},
	function(obj, v)
		setOutlineColorG(v)
	end):addText("G"):setTextColor(0xffffff))
g:add(ui:hSlider(
	0, 255, color[3] * 255, false,
	{Pixel.new(0,1,100,20), Pixel.new(0x0000ff,1,20,20)},
	function(obj, v)
		setOutlineColorB(v)
	end):addText("B"):setTextColor(0xffffff))
g:add(ui:hSlider(
	0, 255, color[4] * 255, false,
	{Pixel.new(0,1,100,20), Pixel.new(0xffffff,1,20,20)},
	function(obj, v)
		setOutlineColorA(v)
	end):addText("A"):setTextColor(0x2f2f2f))
g:add(ui:hSlider(
	0, 1, 0.5, false,
	{Pixel.new(0,1,100,20), Pixel.new(0x0fafcf,1,20,20)},
	function(obj, v)
		shader:setConstant("fDisolve", Shader.CFLOAT, 1, v)
	end):addText("Disolve"):setTextColor(0xffffff))
g:add(ui:hSlider(
	0, 0.5, 0.1, false,
	{Pixel.new(0,1,100,20), Pixel.new(0x0fafcf,1,20,20)},
	function(obj, v)
		shader:setConstant("fDisolveStrokeWidth", Shader.CFLOAT, 1, v)
	end):addText("Stroke"):setTextColor(0xffffff))
