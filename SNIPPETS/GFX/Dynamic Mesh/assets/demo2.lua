application:setBackgroundColor(0x00007f)
-- Instantiate class. Look in class Lua file for contructor arguments
local tail = Tail.new({
--	numPoints=30, width=20, color=0xEF4DB6, gradient=true
	numPoints=16*8, width=8, color=0xEF4DB6, gradient=true,
})
stage:addChild(tail)

local function onMouseHover(ev) tail:addPoint(ev.x, ev.y) end
stage:addEventListener(Event.MOUSE_HOVER, onMouseHover)
