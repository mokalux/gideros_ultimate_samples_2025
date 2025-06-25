json 	= require "json"
utils 	= require "utils"
local ScreenManager 	= require "screens.ScreenManager"
local NetworkManager 	= require "NetworkManager" 

application:setBackgroundColor(0)

-- Screen size and game scale
screenWidth, screenHeight = utils:getScreenSize()
mainScale = screenHeight / 64
screenWidth, screenHeight = screenWidth / mainScale, screenHeight / mainScale

-- Setup network manager
networkManager = NetworkManager.new()

-- Setup screen manager
screenManager = ScreenManager.new()
screenManager:setScale(mainScale)
stage:addChild(screenManager)
screenManager:loadScreen("MenuScreen", false)