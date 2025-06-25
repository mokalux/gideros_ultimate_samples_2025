-- set background
stage:setBackgroundColor(0,0,0)

--initilize lightning
local light = Lightning.new()
stage:addChild(light)

--generate random coordinates at one of the sides
local function randomSide()
	local startX, startY
	local rand = math.random()
	if(rand <= 0.25) then
		startX = math.random(0,application:getContentWidth())
		startY = 0
	elseif(rand <= 0.5) then
		startX = math.random(0,application:getContentWidth())
		startY = application:getContentHeight()
	elseif(rand <= 0.75) then
		startX = 0
		startY = math.random(0,application:getContentHeight())
	elseif(rand <= 1) then
		startX = application:getContentWidth()
		startY = math.random(0,application:getContentHeight())
	end
	return startX, startY
end

--show lightning on mouse down
local function onMouseDown(e)
	local startX, startY = randomSide()
	light:show(startX, startY, e.x, e.y)
end
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)

--redraw lightning on mouse move
local function onMouseMove(e)
	light:hide()
	local startX, startY = randomSide()
	light:show(startX, startY, e.x, e.y)
end
stage:addEventListener(Event.MOUSE_MOVE, onMouseMove)

--hide lightning on mouse up
local function onMouseUp(e)
   light:hide()
end
stage:addEventListener(Event.MOUSE_UP, onMouseUp)