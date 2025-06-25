--[[
Projectile Class
@Author : Rere
]]

Projectile = gideros.class(Sprite)

function Projectile:init(texture, speed, direction)
	local bitmap = Bitmap.new(Texture.new(texture))
	bitmap:setAnchorPoint(0.5,0.5)
	self.isExploded = false
	self:setParameter(speed, direction)
	
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	local x, y = self:getPosition()
	
	body:setPosition(x,y)
	body.object = self
	body.type = "Projectile"
	
	local circle = b2.CircleShape.new(x, y, bitmap:getWidth() / 2)
	local fixture = body:createFixture{shape = circle, density = 0.1, 
	friction = 0.1, restitution = 0.2}
	--fixture:setFilterData({categoryBits = POLICE_MASK, maskBits = NICK_MASK + POLICE_MASK, groupIndex = 0})
	
	self.body = body
	
	self:addChild(bitmap)
	self:setPosition(150,150)
end

function Projectile:setParameter(speed, direction, distance, offsetSpeed)
	self.speed = speed
	self.isExploded = false
	self.distanceCounter = 0
	self.distance = distance
	self.direction = direction * math.pi / 180 -- from degree to rad
	self.speedX = speed * math.cos(self.direction)
	self.speedY = speed * math.sin(self.direction)
	self.offsetSpeed = offsetSpeed
end

function Projectile:update()
	self.body:setPosition(self:getPosition())
	if self.distance > self.distanceCounter then
		self:setX(self:getX() + self.speedX)
		self:setY(self:getY() + self.speedY + self.offsetSpeed)
		self.distanceCounter = self.distanceCounter + 1
	else
		self.isExploded = true
	end
end

function Projectile:reset()
	self:setPosition(-150,-150)
	--self:setAlpha(0)
	self.body:setPosition(self:getPosition())
end