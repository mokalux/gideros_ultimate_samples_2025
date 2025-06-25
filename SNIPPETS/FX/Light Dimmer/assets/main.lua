------------------------------------------
--------------- main.lua -----------------
------------------------------------------
local BRIGHTNESS = 100

local w = application:getDeviceWidth()
local h = application:getDeviceHeight()

local bulb = Bitmap.new(Texture.new("Images/light_bulb.png"))
stage:addChild(bulb)

local slit = Bitmap.new(Texture.new("Images/slit.png"))
slit:setAnchorPoint(0, 0.5)
local knob = Bitmap.new(Texture.new("Images/knob.png"))
knob:setAnchorPoint(0.5, 0.5)
local dimmer = Slider.new(slit, knob)
local margin = (w - dimmer:getWidth()) / 2 -- at the left
dimmer:setPosition(margin, h - 100)
stage:addChild(dimmer)

dimmer:setValue(BRIGHTNESS)

local function onEnterFrame(event)
	local gray = dimmer:getValue() / 100 -- in range of [0, 1]
	bulb:setColorTransform(gray, gray, gray)
end

stage:addEventListener(Event.ENTER_FRAME, onEnterFrame)
