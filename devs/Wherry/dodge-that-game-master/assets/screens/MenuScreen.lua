local Screen 	 = require "screens.Screen"
local MenuBackground = require "MenuBackground"

local MenuScreen = Core.class(Screen)

function MenuScreen:load()
	self.background = MenuBackground.new()
	self:addChild(self.background)

	self.time = 0
	self.logo = Bitmap.new(Texture.new("assets/logo.png", false))
	self.logo:setX(screenWidth / 2 - self.logo:getWidth() / 2)
	self.logo:setY(4)
	self:addChild(self.logo)

	self.startGameButton = TextField.new(nil, "Start game")
	self.startGameButton:setTextColor(0xFF517F)
	self.startGameButton:setX(screenWidth / 2  - self.startGameButton:getWidth() / 2)
	self.startGameButton:setY(screenHeight / 2 + self.startGameButton:getHeight() / 2)
	self:addChild(self.startGameButton)
	self.startGameButton:addEventListener(Event.TOUCHES_END, self.onButtonClicked, self)
end

function MenuScreen:unload()
	self:removeChild(self.background)
	self.background = nil

	self:removeChild(self.logo)
	self.logo = nil

	self.startGameButton:removeEventListener(Event.TOUCHES_END, self.onButtonClicked, self)
	self:removeChild(self.startGameButton)
	self.startGameButton = nil
end

function MenuScreen:onButtonClicked(e)
	if self.startGameButton:hitTestPoint(e.touch.x, e.touch.y) then
		screenManager:loadScreen("GameScreen")
	end
end

function MenuScreen:update(deltaTime)
	self.background:update(deltaTime)
	self.logo:setY(4 + math.cos(self.time * 3) * 2)
	self.startGameButton:setRotation(math.cos(self.time * 1.5) * 2)
	self.time = self.time + deltaTime
end

return MenuScreen