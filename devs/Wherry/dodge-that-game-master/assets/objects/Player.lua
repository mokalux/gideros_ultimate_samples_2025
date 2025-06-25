local PolarObject = require "objects.PolarObject"

local Player = Core.class(PolarObject)

Player.LINE_SWITCH_TIME = 0.2
Player.DEFAULT_VELOCITY = 30

function Player:init(radius, angle, _, colorName)
	if not colorName then
		colorName = "blue"
	end
	self:setVelocity(Player.DEFAULT_VELOCITY)
	self.switchingLine = false

	self.lightingBmp = Bitmap.new(Texture.new("assets/player_light.png"))
	self.lightingBmp:setAnchorPoint(0.5, 0.5)
	self:addChild(self.lightingBmp)

	local texture = Texture.new("assets/player_" .. colorName .. ".png")
	self:setTexture(texture)

	self.type = "player"
end

function Player:update(deltaTime)
	if self.switchingLine then 
		self.currentPolarRadius = self.currentPolarRadius  + self.lineSwitchSpeed * deltaTime
		if math.abs(self.polarRadius - self.currentPolarRadius) < math.abs(2 * self.lineSwitchSpeed * deltaTime) then 
			self.currentPolarRadius = self.polarRadius
			self.switchingLine = false
		end
		self.angularVelocity = self.velocity / self.currentPolarRadius
	end
	self.super.update(self, deltaTime)

	self.lightingBmp:setAlpha((math.sin(self.timeAlive * 5) + 1) / 2)
end

function Player:setRadius(radius)
	self.super.setRadius(self, radius)
	self.switchingLine = true
	self.lineSwitchSpeed = (self.polarRadius - self.currentPolarRadius) / Player.LINE_SWITCH_TIME
end

return Player