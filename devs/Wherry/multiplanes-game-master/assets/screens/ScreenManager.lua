local MenuScreen = require "screens.MenuScreen"
local GameScreen = require "screens.GameScreen"
local HostScreen = require "screens.HostScreen"
local JoinScreen = require "screens.JoinScreen"

local ScreenManager = Core.class(Sprite)

function ScreenManager:init()
	self.currentScreen = nil

	self.screens = {
		MenuScreen = MenuScreen,
		GameScreen = GameScreen,
		HostScreen = HostScreen,
		JoinScreen = JoinScreen
	}

	self:addEventListener(Event.ENTER_FRAME, self.update, self)
end

function ScreenManager:loadScreen(screenName, ...)
	if not self.screens[screenName] then
		print("Error loading screen '" .. tostring(screenName) .. "': screen not found.")
		return false
	end
	-- Hide current screen
	if self.currentScreen then
		if self.currentScreen:getParent() then
			self:removeChild(self.currentScreen)
		end
		self.currentScreen:unload()
	end
	-- Create and show new screen
	local ScreenClass = self.screens[screenName]
	self.currentScreen = ScreenClass.new()
	self:addChild(self.currentScreen)
	self.currentScreen:load(...)
	return true
end

function ScreenManager:update(e)
	if self.currentScreen then
		self.currentScreen:update(e.deltaTime)
	end
end

return ScreenManager