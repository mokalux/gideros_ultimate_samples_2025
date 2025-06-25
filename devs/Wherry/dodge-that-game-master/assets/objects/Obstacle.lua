local PolarObject = require "objects.PolarObject"

local Obstacle = Core.class(PolarObject)	

function Obstacle:init(radius, angle)
	local direction = 1
	if math.random(1, 2) == 2 then
		direction = -1
	end
	self:setVelocity(math.random(10, 20) * direction)

	local texture = Texture.new("assets/obstacle.png", false)
	self:setTexture(texture)

	self.type = "obstacle"
end

function Obstacle:update(deltaTime)
	self.super.update(self, deltaTime)
	self.bmp:setRotation(self.bmp:getRotation() + deltaTime * 360 * 1)
end

return Obstacle