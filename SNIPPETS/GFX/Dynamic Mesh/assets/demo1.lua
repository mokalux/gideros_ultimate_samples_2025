-- Make a gradient filled Mesh (non essential to example)
local bgrd = Mesh.new()
bgrd:setVertices(1, -100, -100, 2, 1060, -100, 3, 1060, 740, 4, -100, 740) 
bgrd:setIndexArray(1, 2, 3, 1, 3, 4) 
bgrd:setColorArray(0x52EDC7, 1.0, 0x52EDC7, 1.0, 0x5AC8FB, 0.5, 0x5AC8FB, 0.5) 
stage:addChild(bgrd)

-- Make a container that will act as the game world that will scroll LEFT as the block moves RIGHT to keep the game in view
local scene = Sprite.new()
stage:addChild(scene)

-- Instantiate class. Look in class Lua file for contructor arguments
local tail = Tail.new({
	numPoints=30, width=20, color=0xEF4DB6, scaleFactor=0.98, gradient=true
})
scene:addChild(tail)

-- Make our block that will appear to be the tail emitter
local block = Shape.new()
block:setFillStyle(Shape.SOLID, 0xC643FC8)
block:beginPath()
block:moveTo(-1, -1)
block:lineTo(1, -1)
block:lineTo(1, 1)
block:lineTo(-1, 1)
block:closePath()
block:endPath()
block:setScale(25, 25)
block:setPosition(400, 320)
scene:addChild(block)

-- Some control and movement properties
block.mouseDown = false
block.vx = 10
block.vy = 0

-- Used to control the block up and down state (non essential to example)
local function onMouse(event)
	if event:getType() == Event.MOUSE_DOWN then
		block.mouseDown = true
	elseif event:getType() == Event.MOUSE_UP then
		block.mouseDown = false
	end
end

stage:addEventListener(Event.MOUSE_DOWN, onMouse)
stage:addEventListener(Event.MOUSE_UP, onMouse)

-- IMPORTANT
local function onEnterFrame(event)
	
	-- Movement code
	if block.mouseDown then
		if block.vy > -15 then
--			block.vy = block.vy - 1
			block.vy -= 0.03
		end
	else
		if block.vy < 15 then
--			block.vy = block.vy + 0.75
			block.vy += 0.0075
		end
	end
	
	local angle = math.deg(math.atan2(block.vy, block.vx))
	block:setRotation(angle)
	
	block:setX(block:getX() + block.vx)
	block:setY(block:getY() + block.vy)
	
	scene:setX(400 - block:getX())
	
	-- HERE IS THERE IMPORTANT PART
	-- We are using addPoint method on Tail instance object and adding a new point whre the block is CURRENTLY
	-- The tail and block are in the same Sprite, but the block is moving and will give the tail the appearance of being "left behind"... well sort of ;)
	tail:addPoint(block:getX(), block:getY())

end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
