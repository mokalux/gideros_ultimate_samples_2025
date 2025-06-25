Zombie = Core.class(Sprite)

function Zombie:init()
	self.sprite = AnimatedSprite.new(Texture.new("gfx/zombie_"..math.random(1,4)..".png"), 16, 23)
	self:addChild(self.sprite)
	self.sprite.delay = 0.12
	self.sprite:setScale(gameScale, gameScale)
	self.width = 8 * gameScale
	
	local speedRandom = math.random(1, 4)
	if speedRandom <= 3 then
		self.speed = 15
	else
		self.speed = 27
	end
end

function Zombie:checkCollision(x, y)
	if	x >= self:getX() and x <= self:getX() + self.width and 
		y >= self:getY() and y <= self:getY() + self:getHeight()
	then
		return true
	end
	return false
end

function Zombie:update(e)
	self.sprite:update(e.deltaTime)
end

function Zombie:checkCollision(x, y)
	if	x >= self:getX() and x <= self:getX() + self:getWidth() and 
		y >= self:getY() and y <= self:getY() + self:getHeight() 
	then
		return true
	end
	return false
end