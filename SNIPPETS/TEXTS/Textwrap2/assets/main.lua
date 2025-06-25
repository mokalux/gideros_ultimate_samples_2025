local file = io.open("bebad.txt", "r")
local str = file:read("*all")
file:close()
local font = TTFont.new("Roboto-Regular.ttf", 42)

--TextWrap2:init(text, areaWidth, areaHeight, lineSpacing, letterSpacing, align, font, mainColor, color1)
--str = str:gsub("\13\10", "\10") -- convert win CRLF to unix LF
local tw = TextWrap2.new(str, 128*5, 480, 42, 5, "center", font, 0x0000FF, 0x11FC00)
stage:addChild(tw)

local y, sy = 0, 0
local function onMouseDown(event) sy = event.y end
local function onMouseMove(event)
	local dy = sy - event.y
	y += dy
	sy = event.y
	tw:setScrollPosition(0, y)
end
local function onMouseUp(event)
end
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)
stage:addEventListener(Event.MOUSE_MOVE, onMouseMove)
stage:addEventListener(Event.MOUSE_UP, onMouseUp)

local function onEnterFrame()
	y += 0.1
	tw:setScrollPosition(0, y)
end
stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
