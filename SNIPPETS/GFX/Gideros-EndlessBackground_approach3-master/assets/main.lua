print("initial test")

local scaleFactor = 2.5

local witdh = application:getDeviceWidth()*scaleFactor
local height = application:getDeviceHeight()*scaleFactor

local e = EndlessBackground2D.new(width,height)

stage:addChild(e)

local prevX,prevY 
stage:addEventListener(Event.MOUSE_DOWN, function(event)
	prevX = event.x
	prevY = event.y
end)

stage:addEventListener(Event.MOUSE_MOVE, function(event)
	local dx = event.x - prevX
	local dy = event.y - prevY
	e:moveBy(dx,dy)
	prevX = event.x
	prevY = event.y
end)
