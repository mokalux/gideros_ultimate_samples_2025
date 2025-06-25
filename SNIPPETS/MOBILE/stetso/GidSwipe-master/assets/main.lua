-- GidSwipe example
-- lots of setup for such a simple library :)
-- Have fun with it! Feedback and suggestions are appreciated...

--------------------------------------------------
-------------------- Setup -----------------------
local function clamp(x, min, max) return x < min and min or (x > max and max or x) end

application:setBackgroundColor(0x343434)
local scrW = application:getContentWidth()
local scrH = application:getContentHeight()

local text = TextField.new(nil, "Tap or swipe in any direction!")
text:setAnchorPoint(0.5,0.5)
text:setTextColor(0xFAFAFA)
text:setPosition(scrW/2,scrH/4)
text:setScale(2,2)
stage:addChild(text)

local resultTxt = TextField.new(nil, ".")
resultTxt:setAnchorPoint(0.5,0.5)
resultTxt:setTextColor(0xF47678)
resultTxt:setPosition(scrW/2,scrH/1.5)
resultTxt:setScale(3,3)
stage:addChild(resultTxt)

stage:addEventListener(Event.ENTER_FRAME, function(ev)
	local currAlpha = resultTxt:getAlpha()
	resultTxt:setAlpha(clamp(currAlpha, 0, currAlpha-0.02))
end)

local function updateText(txt)
	resultTxt:setText(txt)
	resultTxt:setPosition(scrW/2,scrH/1.5)
	resultTxt:setAnchorPoint(0.5,0.5)
	resultTxt:setAlpha(1)
end

--------------------------------------------------
----------- GidSwipe example usage ---------------
local swiper = GidSwipe.new()
-- the events are emitted to the stage
stage:addEventListener(Event.TAP, function(ev)
	updateText("tap")
end)
stage:addEventListener(Event.SWIPE, function(ev)
	updateText("swipe "..ev.direction)
end)

-- play with number of directions
--swiper:setOption("nSwipeDirections", 8) 
-- and/or set other options (see GidSwipe.lua)

