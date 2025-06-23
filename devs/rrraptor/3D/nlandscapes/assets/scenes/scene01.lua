Scene01 = Core.class(Sprite)

function Scene01:init()
	-- BG
	application:setBackgroundColor(0x323232)
	application:configureFrustum(45, 32*48)
	-- some vars
	local sprite = Sprite.new()
--	local width, height, cellSize = 1024, 16, 128
--	local width, height, cellSize = 32, 8, 4
	local width, height, cellSize = 64, 64, 32
	self.timer = 0
	self.colorArray = {
		{0.2, 0xff63c3},
		{0.3, 0x3666c6},
		{0.4, 0xd1d080},
		{0.5, 0x589718},
		{0.6, 0x3f6a14},
		{0.7, 0x5c443d},
		{0.9, 0x4b3c37},
		{1.0, 0xffffff},
	}
	-- the landscapes: water
	local watermesh = self:rectMesh(width, height, cellSize, 0x0000ff, 0.7)
	watermesh:setAnchorPoint(0.5,0.5)
	-- the landscapes: ground
	local groundmesh = self:meshGrid(width, height, cellSize, 32)
	groundmesh:setAnchorPoint(0.5,0.5)
--	groundmesh:setX(128)
--	groundmesh:setY(-128)
--	groundmesh:setZ(128*2)
	groundmesh:setScale(0.25)
	-- order
	self:addChild(groundmesh)
--	self:addChild(watermesh)
	self:setPosition(myappwidth/2, myappheight/2)
	self:setRotationX(80) -- 45
--	sprite:addChild(groundmesh)
--	sprite:setPosition(myappwidth/2, myappheight/2)
--	sprite:setRotationX(15) -- 45
	-- render target
	self.rt = RenderTarget.new(self:getWidth(), self:getHeight())
--	self.rt = RenderTarget.new(sprite:getWidth(), sprite:getHeight())
	local bmp = Bitmap.new(self.rt)
	self:addChild(bmp)
	-- LISTENERS
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

function Scene01:meshGrid(width, height, cellSize, extrusion)
	extrusion = extrusion or 50
	local mesh = Mesh.new(true)
	local v = 1
	local i = 1
	local n = Noise.new()
	n:setFrequency(0.08)
	n:setFractalOctaves(12)
	n:setNoiseType(Noise.SIMPLEX_FRACTAL)
	n:setColorLookup(self.colorArray)
	local tex = n:getTexture(width, height, true)
	mesh:setTexture(tex)
	for y = 1, height+1 do 
		for x = 1, width+1 do 
			local nv = n:noise(x, y)
			mesh:setVertex(v, (x - 1) * cellSize, (y - 1) * cellSize, nv * extrusion)
			mesh:setTextureCoordinate(v, x - 1, y - 1)
			if (x <= width and y <= height) then 
				local a = y * (width + 1) + x + 1
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

function Scene01:rectMesh(width, height, cellSize, color, alpha)
	local mesh = Mesh.new(true)
	mesh:setVertex(1, 0, 0, 0)
	mesh:setVertex(2, width * cellSize, 0, 0)
	mesh:setVertex(3, width * cellSize, height * cellSize, 0)
	mesh:setVertex(4, 0, height * cellSize, 0)
	mesh:setColorArray(
		color, alpha,
		color, alpha,
		color,alpha,
		color,alpha
	)
	mesh:setIndexArray(1,2,3, 1,3,4)
	return mesh
end

-- LOOP
function Scene01:onEnterFrame(e)
	local dt = e.deltaTime
--	self:setZ(math.sin(self.timer)*200)
--	self:setX(math.cos(self.timer)*512*2)
	self:setRotation(self:getRotation() + 8*dt)
	self.rt:draw(self)
end

-- EVENT LISTENERS
function Scene01:onTransitionInBegin()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
function Scene01:onTransitionInEnd()
	self:myKeysPressed()
end
function Scene01:onTransitionOutBegin()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
function Scene01:onTransitionOutEnd() end

-- KEYS HANDLER
function Scene01:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then
--			scenemanager:changeScene("menu", 1, transitions[2], easings[2])
		end
	end)
end
