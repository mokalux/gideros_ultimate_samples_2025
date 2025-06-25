require "box2d"

Nick = Core.class(Sprite)

function Nick:init()
	self.sprite = Bitmap.new(Texture.new("images/robber.png", true))
	self.sprite:setAnchorPoint(0.5, 0.5)
	self.sprite:setPosition(self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
	self.sprite:setRotation(180)
	self:setPosition((conf.screenWidth - self.sprite:getWidth()) / 2, conf.screenHeight - self.sprite:getHeight() - 300)
	self:addChild(self.sprite)
	
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(self:getPosition())
	body.object = self
	body.type = "Nick"
	
	local circle = b2.CircleShape.new(self.sprite:getWidth() / 2, self.sprite:getHeight() / 2,
		self.sprite:getWidth() / 2)
	local fixture = body:createFixture{shape = circle, density = 1.0, 
	friction = 0.0, restitution = 0.2}
	
	self.body = body
	self.health = NICK_MAXHEALTH
	self.defense = NICK_DEFENCE
	self.MAX_SPEED = 0.2
	self.curSpeedX = 0
	self.curSpeedY = 0
end

function Nick:getHealth()
	return self.health
end

function Nick:getDefense()
	return self.defense
end

function Nick:getSpeed()
	return self.curSpeedX, self.curSpeedY
end

function Nick:setHealth(hp)
	if hp >= 0 then
		self.health = hp
	end
end

function Nick:setDefense(def)
	self.defense = def
end

function Nick:setSpeed(speedX, speedY)
	self.curSpeedX = speedX
	self.curSpeedY = speedY
end

function Nick:reset()
	self.health = NICK_MAXHEALTH
	self.curSpeedX = 0
	self.curSpeedY = 0
	self.sprite:setRotation(180)
	self:setPosition((conf.screenWidth - self.sprite:getWidth()) / 2, conf.screenHeight - self.sprite:getHeight() - 300)
	self.body:setPosition(self:getPosition())
end

function Nick:resetDefense()
	self.defense = NICK_DEFENCE
end

function Nick:move()
	self.sprite:setRotation(math.atan2(self.curSpeedY, self.curSpeedX) * 180 / math.pi - 90)
	self:checkPosition()
end

function Nick:checkPosition()
	local xPos, yPos = self.body:getPosition()
	
	if xPos < 0 then
		self.curSpeedX = 0
		xPos = 0
	elseif xPos > conf.screenWidth - self.sprite:getWidth() then
		self.curSpeedX = 0
		xPos = conf.screenWidth - self.sprite:getWidth()
	end
	
	if yPos < 0 then
		self.curSpeedY = 0
		yPos = 0
	elseif yPos > conf.screenHeight - self.sprite:getHeight() - 280 then
		self.curSpeedY = 0
		yPos = conf.screenHeight - self.sprite:getHeight() - 280
	end
	
	self.body:setPosition(xPos, yPos)
	self.body:setLinearVelocity(self.curSpeedX, self.curSpeedY)
end