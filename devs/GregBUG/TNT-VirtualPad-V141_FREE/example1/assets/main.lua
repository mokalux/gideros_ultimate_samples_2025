--
-- TNT Virtual Pad for Gideros Mobile SDK
-- Example 1
-- custom texture on button1

-- note that in the texture MUST be present (at least for now) the "standard" base vPad texture named:
-- tntvpad_analogpad.png        standard gfx for stick
-- tntvpad_base.png             standard gfx for base stick
-- tntvpad_buttondown.png       standard gfx for button down
-- tntvpad_buttonup.png			standard gfx for button up

-- (you can find default gfx in the "pad_gfx_templates" folder)
--
-- Copyright (C) 2012 By Gianluca D'Angelo
-- 
--local function is32bit()
--	return string.dump(is32bit):byte(9) == 4
--end

--if is32bit() then
--	require("tntvpad32")
--else
--	require("tntvpad64")
--end
require("tntvirtualpadx")

-- Setup App
application:setKeepAwake(true)
application:setBackgroundColor(0x000000)

-- load background 
local back = Bitmap.new(Texture.new("sfondo3.png"))
stage:addChild(back)

-- setup player
local biPlane = CLASS_biPlane.new()
stage:addChild(biPlane)

-- setup Virutal Pad
--local vPad = CTNTVirtualPad.new(stage, "tntskinpad",  PAD.STICK_SINGLE, PAD.BUTTONS_TWO, 20,2)
local texturevpad = TexturePack.new("tntskinpad.txt", "tntskinpad.png", true)
local vPad = CTNTVirtualPad.new(stage, texturevpad, PAD.STICK_SINGLE, PAD.BUTTONS_TWO, 20, 2)

vPad:setTextures(PAD.COMPO_BUTTON1, "buttona.png","buttonb.png")
vPad:setJoyStyle(PAD.COMPO_LEFTPAD, PAD.STYLE_MOVABLE)
vPad:setJoyAsAnalog(PAD.COMPO_LEFTPAD, false)
vPad:setJoyAsAnalog(PAD.COMPO_RIGHTPAD, true)
--vPad:setICade(false)
vPad:start()

local function leftJoy(e)
	if e.data.power > 0.2 then
		biPlane:move(e.data.angle, (e.data.power*150)*e.data.deltaTime)
	end
end

local function rightJoy(e)
	if e.data.selected then
		biPlane:setRotation(math.deg(e.data.angle*.786)+90)
	end
end

local function fire(e)
	if e.data.state == PAD.STATE_BEGIN then
		local fire = CLASS_fire.new(biPlane.xPos, biPlane.yPos-20)
		stage:addChild(fire)
	end
end

local function protection(e)
	if e.data.state == PAD.STATE_DOWN then
		biPlane.protection:setVisible(true)
	else
		biPlane.protection:setVisible(false)
	end
end

vPad:addEventListener(PAD.LEFTPAD_EVENT, leftJoy, self)
vPad:addEventListener(PAD.BUTTON1_EVENT, fire, self)
vPad:addEventListener(PAD.BUTTON2_EVENT, protection, self)
