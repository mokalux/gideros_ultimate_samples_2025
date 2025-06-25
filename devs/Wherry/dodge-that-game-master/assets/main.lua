utils 			= require "utils"

local ScreenManager 	= require "screens.ScreenManager"
local FramerateCounter 	= require "FramerateCounter"

application:setBackgroundColor(0x170D0F)

screenWidth, screenHeight = utils:getScreenSize()
mainScale = screenHeight / 140
screenWidth, screenHeight = screenWidth / mainScale, screenHeight / mainScale

-- Setup screen manager
screenManager = ScreenManager.new()
screenManager:setScale(mainScale)
stage:addChild(screenManager)
screenManager:loadScreen("GameScreen", false)

-- Show fps
local framerateCounter = FramerateCounter.new()
stage:addChild(framerateCounter)
-- framerateCounter:setScale(mainScale * 0.5)
