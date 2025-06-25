Plotter = Core.class(Sprite)

function Plotter:init()
	-- config
	application:setBackgroundColor(0x222222)
	application:configureFrustum(30, -0.1)
	-- some vars
	local width, height, cellSize = 64, 64, 8 -- 96, 64, 4
	local viewangle = 80 -- 30
	-- water (rectMesh)
	self.waterMesh = self:rectMesh(width, height, cellSize, 0x55ffff, 0.3)
	self.waterMesh:setAnchorPoint(0.5,0.5)
	self.waterMesh:setPosition(myappwidth/2, myappheight/2 + 0*16)
	self.waterMesh:setRotationX(viewangle)
	self:addChild(self.waterMesh)
	-- terrainMesh
	self.colorArray = {
		{0.3, 0x3463c3}, {0.4, 0x3666c6}, {0.4, 0xd1d080}, {0.5, 0x589718},
		{0.6, 0x3f6a14}, {0.7, 0x5c443d}, {0.9, 0x4b3c37}, {1.0, 0xffffff},
	}
	self.terrainMesh = self:meshGrid(width, height, cellSize, 64, self.colorArray)
	self.terrainMesh:setAnchorPoint(0.5,0.5)
	self.terrainMesh:setPosition(myappwidth/2, myappheight/2 - 0.5*16)
	self.terrainMesh:setRotationX(viewangle)
	self:addChild(self.terrainMesh)
	-- cubeMesh
	self.cube = self:cubeMesh(width/2, height/2, cellSize, 0xff00ff, 1)
	self.cube:setAnchorPoint(0.5,0.5)
	self.cube:setPosition(myappwidth/2, myappheight/2 - 128)
	self.cube:setRotationX(0)
	self.cube:setRotationY(-5)
--	self:addChild(self.cube)
	-- cubeMesh2
	local va = {
		0, 25, 25,
		25, 25, 25,
		25, 0, 0,
		0, 0, 0,

		0, 25, 50,
		25, 25, 50,

		0, 25, 75,
		25, 25, 75,
	}
	local vc = {
		0xffff00,0.7, 0xffff00,0.7, 0xffff00,0.7, 0xffff00,0.7,
		0xff0000,0.7, 0xff0000,0.7, 0xff0000,0.7, 0xff0000,0.7,
	}
	local ia = {
		2,1,3, 1,4,3,
		6,5,2, 5,1,2,

		6,5,2, 5,1,2,

		8,7,6, 7,5,6,
	}
	self.cube2 = self:cubeMesh2(va, vc, ia)
	self.cube2:setAnchorPoint(0.5,0.5)
	self.cube2:setPosition(myappwidth/2, myappheight/2 + 196)
--	self.cube2:setRotationX(0)
--	self.cube2:setRotationY(-5)
--	self:addChild(self.cube2)

	-- let's go!
	self:onWindowResize()
	-- LISTENERS
	self:addEventListener("applicationResize", self.onWindowResize, self)
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Plotter:rectMesh(width, height, cellSize, color, alpha)
	local mesh = Mesh.new(true)
	mesh:setVertex(1, 0, 0, 0)
	mesh:setVertex(2, width*cellSize, 0, 0)
	mesh:setVertex(3, width*cellSize, height*cellSize, 0)
	mesh:setVertex(4, 0, height*cellSize, 0)
	mesh:setColorArray(
		color, alpha,
		color, alpha,
		color, alpha,
		color, alpha
	)
	mesh:setIndexArray(1,2,3, 1,3,4)
	return mesh
end

function Plotter:meshGrid(width, height, cellSize, extrusion, colorArray)
	extrusion = extrusion or 50
	local mesh = Mesh.new(true)
	local v = 1
	local i = 1
	local n = Noise.new()
	n:setFrequency(0.04)
	n:setFractalOctaves(10)
	n:setNoiseType(Noise.SIMPLEX_FRACTAL)
	n:setColorLookup(colorArray)
	local tex = n:getTexture(width, height, true)
	mesh:setTexture(tex)
	for y = 1, height+1 do 
		for x = 1, width+1 do 
			local nv = n:noise(x, y)
			mesh:setVertex(v, (x-1)*cellSize, (y-1)*cellSize, nv*extrusion)
			mesh:setTextureCoordinate(v, x-1, y-1)
			if x <= width and y <= height then
				local a = y*(width+1) + x + 1
				mesh:setIndex(i + 0, v)
				mesh:setIndex(i + 1, v + 1)
				mesh:setIndex(i + 2, a)
				mesh:setIndex(i + 3, v)
				mesh:setIndex(i + 4, a)
				mesh:setIndex(i + 5, a - 1)
				i += 6
			end
			v += 1
		end
	end
	return mesh
end

function Plotter:cubeMesh(width, height, cellSize, color, alpha)
	local alpha = alpha - 0.5
	local mesh = Mesh.new(true) -- 3D
	--   5  6
	-- 1--2
	--  |8 |7
	-- 4--3
--[[
	mesh:setVertex(1, 0, 0, 50)
	mesh:setVertex(2, width * cellSize, 0, 50)
	mesh:setVertex(3, width * cellSize, height * cellSize, 50)
	mesh:setVertex(4, 0, height * cellSize, 50)

	mesh:setVertex(5, 0, 0, -50)
	mesh:setVertex(6, width * cellSize, 0, -50)
	mesh:setVertex(7, width * cellSize, height * cellSize, -50)
	mesh:setVertex(8, 0, height * cellSize, -50)
]]
	local va = {
		0, 0, 50,
		width * cellSize, 0, 50,
		width * cellSize, height * cellSize, 50,
		0, height * cellSize, 50,

		0, 0, -50,
		width * cellSize, 0, -50,
		width * cellSize, height * cellSize, -50,
		0, height * cellSize, -50,
	}
	mesh:setVertexArray(va)
	mesh:setColorArray(
		color,alpha, color,alpha, color,alpha, color,alpha,
		0xff0000,alpha, 0xff0000,alpha, 0xff0000,alpha, 0xff0000,alpha
	)
--[[
	mesh:setIndexArray(
		2,1,3, 1,4,3,
		6,5,7, 5,8,7,

		1,5,4, 5,8,4,
		6,2,7, 2,3,7
	)
]]
	local ia = {
		2,1,3, 1,4,3,
		6,5,7, 5,8,7,

		1,5,4, 5,8,4,
		6,2,7, 2,3,7,
	}
	mesh:setIndexArray(ia)
	return mesh
end

function Plotter:cubeMesh2(xva, xvc, xia)
	local mesh = Mesh.new(true) -- 3D
	mesh:setVertexArray(xva)
	mesh:setColorArray(xvc)
	mesh:setIndexArray(xia)
	return mesh
end

-- GAME LOOP
local angle = 0.5
function Plotter:onEnterFrame(e)
--	self.cube:setRotationX(self.cube:getRotationX()+angle)
--	self.cube:setRotationY(self.cube:getRotationY()-angle)
	self.terrainMesh:setRotation(self.terrainMesh:getRotation()-angle)
	self.waterMesh:setRotation(self.waterMesh:getRotation()-angle)
end

-- EVENT LISTENERS
function Plotter:onWindowResize()
end
function Plotter:onTransitionInBegin()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
function Plotter:onTransitionInEnd() self:myKeysPressed() end
function Plotter:onTransitionOutBegin()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
function Plotter:onTransitionOutEnd() end

-- KEYS HANDLER
function Plotter:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then
--			scenemanager:changeScene("menu", 1, transitions[2], easing.outBack)
		end
	end)
end
