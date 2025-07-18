-- Sprite with anchor support demo
-- https://github.com/nshafer/AnchorSprite

-- The MIT License (MIT)

-- Copyright (c) 2013 Nathan Shafer

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local fontFace = "NotoSans-Regular.ttf"
local fontSize = 12

function createBox(width, height, lineStyle)
	local box = Shape.new()
	box:setLineStyle(unpack(lineStyle))
	box:beginPath()
	box:moveTo(0,0)
	box:lineTo(width,0)
	box:lineTo(width,height)
	box:lineTo(0,height)
	box:closePath()
	box:endPath()
	return box
end



-- Create a black box with default anchor
local box1  = createBox(100, 100, {2, 0x000000, 1})
box1:setPosition(application:getContentWidth()/2, 100)
stage:addChild(box1)

-- Create a black text field with default anchor
local text1 = TextField.new(TTFont.new(fontFace, fontSize), "This has 0,0 anchor")
text1:setPosition(box1:getPosition())
stage:addChild(text1)

-- Animate black box
GTween.new(box1, 5, {rotation=360}, {repeatCount=0})
GTween.new(box1, 5, {scaleX=2, scaleY=2}, {repeatCount=0, reflect=true})

-- Animate black text
GTween.new(text1, 5, {rotation=360}, {repeatCount=0})
GTween.new(text1, 5, {scaleX=2, scaleY=2}, {repeatCount=0, reflect=true})



-- Create a red box with .5 anchor
local box2 = createBox(100, 100, {2, 0xFF0000, 1})
box2:setPosition(application:getContentWidth()/2, 380)
box2:setAnchorPoint(0.5, 0.5)
stage:addChild(box2)

-- Create green box as a child of the red box
local box3 = createBox(100,100, {2, 0x00FF00, 1})
box3:setPosition(box2:getWidth()/2, box2:getHeight()/2)
box3:setAnchorPoint(0.5, 0.5)
box3:setScale(0.5)
box2:addChild(box3)

-- Create a red text field
local text2 = TextField.new(TTFont.new(fontFace, fontSize), "This has 0.5,0.5 anchor")
text2:setPosition(box2:getPosition())
text2:setAnchorPoint(0.5, -0.5) --  Set Y anchor at -0.5 due the bottom of TextFields being at 0
text2:setTextColor(0xFF0000)
stage:addChild(text2)

-- Animate red box
GTween.new(box2, 5, {rotation=360}, {repeatCount=0})
GTween.new(box2, 5, {scaleX=2, scaleY=2}, {repeatCount=0, reflect=true})

-- Animate red text
GTween.new(text2, 5, {rotation=360}, {repeatCount=0})
GTween.new(text2, 5, {scaleX=2, scaleY=2}, {repeatCount=0, reflect=true})



-- Create an FPS counter
local fps = TextField.new(TTFont.new(fontFace, 10), "00")
stage:addChild(fps)
fps:setPosition(5, application:getContentHeight()-5)
local timer = os.timer()
stage:addEventListener(Event.ENTER_FRAME, function(event)
	if event.frameCount % 60 == 0 then
		local currentTimer = os.timer()
		fps:setText(math.ceil(60 / (currentTimer - timer)))
		timer = currentTimer
	end
end)
