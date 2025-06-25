Hero = Core.class(Sprite)

function Hero:init()
end

function Hero:setX(x)
	self:set("x", x)
	self.body:setPosition(self:getX(), self:getY())
end

function Hero:setY(y)
	self:set("y", y)
	self.body:setPosition(self:getX(), self:getY())
end
