--[[
Exampled of inputbox and keyboard
(C) 2012 Mathz Data och Webbutveckling, Mathz Franzén
]]--

application:setBackgroundColor(0xdddddd)

local xpos = -(application:getLogicalTranslateX() / application:getLogicalScaleX())
local ypos = -(application:getLogicalTranslateY() / application:getLogicalScaleY())

local keyboard = KeyBoard.new("ru_RU")
keyboard:Create()
local inputbox = InputBox.new(xpos+20,ypos+20,350,40)

inputbox:setText("test")
inputbox:SetKeyBoard(keyboard)
inputbox:setBoxColors(0xefefef,0xff2222,0,1)
inputbox:setActiveBoxColors(0xff5555,0xff2222,0,1)
stage:addChild(inputbox)

local inputbox2 = InputBox.new(xpos+20,ypos+80,200,20)
inputbox2:SetKeyBoard(keyboard)
inputbox2:setBoxColors(0xefefef,0xff2222,0,0.5)
inputbox2:setActiveBoxColors(0xff5555,0xff2222,0,0.5)
inputbox2:PasswordField(true)
inputbox2:setMaxLetters(10)
stage:addChild(inputbox2)

stage:addChild(keyboard)

local font = TTFont.new("arial.ttf",20,true)
local showValue1 = TextField.new(font,"")
local showValue2 = TextField.new(font,"")
showValue1:setPosition(xpos+20,ypos+150)
showValue2:setPosition(xpos+20,ypos+170)
stage:addChild(showValue1)
stage:addChild(showValue2)

function showValues(event)
	showValue1:setText("Input1: "..inputbox:getText())
	showValue2:setText("Input2: "..inputbox2:getText())
end
stage:addEventListener(Event.MOUSE_UP,showValues, getValues)
