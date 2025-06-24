--
-- TNT Virtual Pad for Gideros Mobile SDK
-- Example 2
--
-- Copyright (C) 2012 By Gianluca D'Angelo
--
local function is32bit()
	return string.dump(is32bit):byte(9) == 4
end

require("tntvirtualpadx")

-- Setup App
application:setKeepAwake(true)
application:setBackgroundColor(0x000000)

-- load background 
local back = Bitmap.new(Texture.new("sfondo3.png"))
stage:addChild(back)

-- setup player
local carro = CLASS_carro.new()
stage:addChild(carro)

-- setup Virutal Pad
--local vPad = CTNTVirtualPad.new(stage, "example2_gfx",  PAD.STICK_DOUBLE, PAD.BUTTONS_ONE, 20, 3)
local texturevpad = TexturePack.new("example2_gfx.txt", "example2_gfx.png", true)
local vPad = CTNTVirtualPad.new(stage, texturevpad, PAD.STICK_DOUBLE, PAD.BUTTONS_TWO, 20, 3)

vPad:setJoyStyle(PAD.COMPO_LEFTPAD, PAD.STYLE_FOLLOW)
vPad:setPosition(PAD.COMPO_BUTTON1, 400, 80)
vPad:setScale(PAD.COMPO_LEFTPAD, 1.5)
vPad:setPosition(PAD.COMPO_LEFTPAD, 80, 220)
vPad:setScale(PAD.COMPO_BUTTON1, 1.8)
--vPad:setMaxRadius(PAD.COMPO_RIGHTPAD, 90)
--vPad:setHideMode(PAD.MODE_HIDDEN)
vPad:start()

local function leftJoy(e)
	if e.data.power > 0.2 then
		carro:move(e.data.angle, (e.data.power*170)*e.data.deltaTime)
	end
end

local function rightJoy(e)
	if e.data.selected then
		carro:rotateCannone(e.data.angle)
	end
end

local function fire(e)
	if e.data.state == PAD.STATE_BEGIN then
		local fire = CLASS_fire.new(carro.xPos+(math.cos(carro.angle+carro.cannoneAngle)*90), carro.yPos+(math.sin(carro.angle+carro.cannoneAngle)*90), carro.angle+carro.cannoneAngle)
		stage:addChild(fire)
	end
end


vPad:addEventListener(PAD.LEFTPAD_EVENT, leftJoy, self)
vPad:addEventListener(PAD.RIGHTPAD_EVENT, rightJoy, self)
vPad:addEventListener(PAD.BUTTON1_EVENT, fire, self)

