local Screen 	 = require "screens.Screen"
local MenuScreen = require "screens.MenuScreen"
local GameScreen = require "screens.GameScreen"

local ScreenManager = Core.class(Sprite)

local FADE_TIME_MS = 500

function ScreenManager:init()
	self.currentScreen = nil

	self.screens = {
		MenuScreen = MenuScreen,
		GameScreen = GameScreen
	}

	self.blackRect = Shape.new()
	self.blackRect:setFillStyle(Shape.SOLID, 0, 1)
	self.blackRect:beginPath()
	self.blackRect:moveTo(0, 0)
	self.blackRect:lineTo(screenWidth, 0)
	self.blackRect:lineTo(screenWidth, screenHeight)
	self.blackRect:lineTo(0, screenHeight)
	self.blackRect:lineTo(0, 0)
	self.blackRect:endPath()
	self:addChild(self.blackRect)
	self.blackRect:setAlpha(0)

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function ScreenManager:loadScreen(newScreen, ...)
	if not self.screens[newScreen] then
		print("Error: wrong screen name")
		return false
	end
	-- Remove current screen
	if self.currentScreen then
		if self.currentScreen:getParent() then
			self:removeChild(self.currentScreen)
		end
		self.currentScreen:unload()
	end
	-- Assign a new screen
	self.currentScreen = self.screens[newScreen].new()
	self:addChild(self.currentScreen)
	-- TODO: fading
	self.currentScreen:load(...)
end

function ScreenManager:onEnterFrame(e)
	if self.currentScreen then
		self.currentScreen:update(e.deltaTime)
	end
end

return ScreenManager