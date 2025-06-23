-- Shadertoy.new(filename|{shadercode}, width, height, obj1, obj2, obj3, obj4)

Shadertoy = {}

local function loadShader(filename)

	local vs = [[
	attribute vec4 POSITION0;
	attribute vec2 TEXCOORD0;

	uniform mat4 g_MVPMatrix;

	varying vec2 fragCoord;
	varying vec2 texCoord;

	void main()
	{
		texCoord = TEXCOORD0;
		gl_Position = g_MVPMatrix * POSITION0;
	}
	]]

	local data
	if type(filename) == "string" then
		local file = io.open(filename)
		data = file:read"*a"
		file:close()
	else
		data = filename[1]
	end

	local ps = [[
	#extension GL_OES_standard_derivatives : enable
	#extension GL_EXT_shader_texture_lod : enable

	vec4 texture2DGrad(sampler2D s, in vec2 uv, vec2 gx, vec2 gy) {
		return texture2D(s, uv);
	}

	vec4 texture2DLod(sampler2D s, in vec2 uv, in float lod) {
		return texture2D(s, uv);
	}

	uniform vec4      iResolution;           // viewport resolution (in pixels)
	uniform float     iGlobalTime;           // shader playback time (in seconds)
	uniform float     iTimeDelta;            // render time (in seconds)
	uniform int       iFrame;                // shader playback frame
	uniform float     iChannelTime[4];       // channel playback time (in seconds)
	uniform vec4      iChannelResolution[4]; // channel resolution (in pixels)
	uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
	uniform sampler2D iChannel0;             // input channel #0. XX = 2D/Cube
	uniform sampler2D iChannel1;             // input channel #1. XX = 2D/Cube
	uniform sampler2D iChannel2;             // input channel #2. XX = 2D/Cube
	uniform sampler2D iChannel3;             // input channel #3. XX = 2D/Cube
	uniform vec4      iDate;                 // (year, month, day, time in seconds)
	uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

	varying vec2 texCoord;
	varying vec2 fragCoord;

	#ifdef GL_ES
	precision mediump float;
	#endif

	]] .. data .. [[

	void main() {
		vec4 color = vec4(0.0,0.0,0.0,1.0);
		mainImage(color, gl_FragCoord.xy);
		color.w = 1.0;
		gl_FragColor = color;
	}
	]]

	return Shader.new(vs, ps, Shader.FLAG_FROM_CODE,
		{
			{name="g_MVPMatrix",type=Shader.CMATRIX,sys=Shader.SYS_WVP, vertex=true},
			{name="g_Color",type=Shader.CFLOAT4,mult=1,sys=Shader.SYS_COLOR},

			{name="iResolution",type=Shader.CFLOAT4,mult=1,vertex=false},
			{name="iGlobalTime",type=Shader.CFLOAT,mult=1,vertex=false},
			{name="iTimeDelta",type=Shader.CFLOAT,mult=1,vertex=false},
			{name="iFrame",type=Shader.CINT,mult=1,vertex=false},
			{name="iChannelTime",type=Shader.CFLOAT,mult=1,vertex=false},
			{name="iChannelResolution",type=Shader.CFLOAT4,mult=1,vertex=false},
			{name="iMouse",type=Shader.CFLOAT4,mult=1,vertex=false},
			{name="iDate",type=Shader.CFLOAT4,mult=1,vertex=false},
			{name="iSampleRate",type=Shader.CFLOAT,mult=1,vertex=false},
			{name="iChannel0",type=Shader.CTEXTURE,mult=1,vertex=false},
			{name="iChannel1",type=Shader.CTEXTURE,mult=1,vertex=false},
			{name="iChannel2",type=Shader.CTEXTURE,mult=1,vertex=false},
			{name="iChannel3",type=Shader.CTEXTURE,mult=1,vertex=false},
			},
			{
			{name="POSITION0",type=Shader.DFLOAT,mult=3,slot=0,offset=0},
			{name="vColor",type=Shader.DUBYTE,mult=0,slot=1,offset=0},
			{name="TEXCOORD0",type=Shader.DFLOAT,mult=2,slot=2,offset=0},
		}
	)
end

function Shadertoy.new(filename, width, height, ch0, ch1, ch2, ch3)

	local effect = loadShader(filename)

	local mesh = Mesh.new()
	mesh:setIndexArray(1,2,3, 1,3,4)
	mesh:setVertexArray(0,0, width,0, width,height, 0,height)
	mesh:setTextureCoordinateArray(0,0, width,0, width,height, 0,height)
	mesh:setShader(effect)

	local texs = {ch0, ch1, ch2, ch3}
	local rs = {0, 0, 0, 0, 0, 0, 0, 0}
	for i = 1, 4 do
		local tex = texs[i]
		if tex then
			local slottex = nil
			if tex.CLAMP and tex.REPEAT then
				slottex = tex
			elseif tex.getWidth and tex.getHeight then
				local w, h = tex:getWidth(), tex:getHeight()
				local ren = RenderTarget.new(w, h, true)
				mesh:addEventListener(Event.ENTER_FRAME, function()
					ren:clear(0, 1)
					ren:draw(tex)
				end)
				slottex = ren
			else
				local ren = RenderTarget.new(width, height, true)
				mesh:addEventListener(Event.ENTER_FRAME, function()
					ren:draw(mesh)
				end)
				slottex = ren
			end
			mesh:setTextureSlot(i - 1, slottex)
			rs[2*i-1], rs[2*i] = slottex:getWidth(), slottex:getHeight()
		end
	end

	local mouseX, mouseY, mouseC, frame, time = 0, 0, 0, 0, 0

	local function onMouseMove(event)
		local x0, y0 = event.x or event.touch.x, event.y or event.touch.y
		local x, y = mesh:globalToLocal(x0, y0)
		if mesh:hitTestPoint(x, y) then mouseX, mouseY = x, y end
	end

	local function onMouseDown(event)
		mouseC = 1
		onMouseMove(event)
	end

	local function onMouseUp(event)
		mouseC = 0
		onMouseMove(event)
	end

	local function onEnterFrame(event)
		frame = frame + 1
		local t = time
		local d = os.date("*t")
		local s = d.hour * 3600 + d.min * 60 + d.sec
		effect:setConstant("iResolution", Shader.CFLOAT4, 1, width, height, 0, 0)
		effect:setConstant("iSampleRate", Shader.CFLOAT, 1, 44100)
		effect:setConstant("iGlobalTime", Shader.CFLOAT, 1, t)
		effect:setConstant("iTimeDelta", Shader.CFLOAT, 1, event.deltaTime)
		effect:setConstant("iFrame", Shader.CINT, 1, frame)
		effect:setConstant("iMouse", Shader.CFLOAT4, 1, mouseX, height - mouseY, mouseC, mouseC)
		effect:setConstant("iChannelTime", Shader.CFLOAT, 4, t, t, t, t)
		effect:setConstant("iChannelResolution", Shader.CFLOAT4, 4,
			rs[1], rs[2], 0, 0, rs[3], rs[4], 0, 0,
			rs[5], rs[6], 0, 0, rs[7], rs[8], 0, 0)
		effect:setConstant("iDate", Shader.CFLOAT4, 1, d.year, d.month, d.day, s)
		time = time + event.deltaTime
	end

	stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
	stage:addEventListener(Event.MOUSE_MOVE, onMouseMove)
	stage:addEventListener(Event.TOUCHES_MOVE, onMouseMove)

	stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)
	stage:addEventListener(Event.TOUCHES_BEGIN, onMouseDown)

	stage:addEventListener(Event.MOUSE_UP, onMouseUp)
	stage:addEventListener(Event.TOUCHES_END, onMouseUp)

	return mesh

end
