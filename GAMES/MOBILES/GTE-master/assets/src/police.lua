--[[
Police Class
@Author : Rere
]]

Police = gideros.class(Sprite)

function Police:init(texture_idle, texture_fire, speed, sound)
	self.bitmap_idle = Bitmap.new(Texture.new(texture_idle))
	self.bitmap_fire = Bitmap.new(Texture.new(texture_fire))
	self.bitmap_idle:setAnchorPoint(0.5,0.5)
	--self.bitmap_idle:setPosition(self.bitmap_idle:getWidth() / 2, self.bitmap_idle:getHeight() / 2)
	self.bitmap_fire:setAnchorPoint(0.5,0.5)
	--self.bitmap_fire:setPosition(self.bitmap_fire:getWidth() / 2, self.bitmap_fire:getHeight() / 2)
	self.gun = nil
	self.targetX = 0
	self.targetY = 0
	self.fireRate = 100
	self.fireRateCounter = 0
	self.speed = speed
	self.sound = sound
	self.timer = Timer.new(250,1)
	
	self.timer:addEventListener(Event.TIMER_COMPLETE, function()
		--self.bitmap_fire:setAlpha(0)
		--self.bitmap_idle:setAlpha(100)
		self:addChild(self.bitmap_idle)	
		self:removeChild(self.bitmap_fire)	
	end)
	
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	local x, y = self:getPosition()
	
	body:setPosition(x,y)
	body.object = self
	body.type = "Police"
	
	local circle = b2.CircleShape.new(x, y, self.bitmap_idle:getWidth() / 2)
	local fixture = body:createFixture{shape = circle, density = 1.0,
	friction = 0.0, restitution = 0.2}
	
	self.body = body
	
	--self.bitmap_fire:setAlpha(0)
	
	self:addChild(self.bitmap_idle)
	self:setPosition(100,100)
end

function Police:setParameter(fireRate, speed)
	self.fireRate = fireRate
	self.speed = speed
end

function Police:turnTo(x, y)
	local dy = (y - self:getY()) * -1
	local dx = x - self:getX()
	local dRotation = 90 - math.atan2(dy,dx) * 180 / math.pi
	self:setRotation(dRotation)
end

function Police:setShootTarget(x,y)
	self.targetX = x
	self.targetY = y
end

function Police:equip(gun)
	self.gun = gun
	self.gun:setPosition(self:getPosition())
end

function Police:getEquip()
	return self.gun
end

function Police:fire()
	--self.bitmap_fire:setAlpha(1)
	--self.bitmap_idle:setAlpha(0)
	self:removeChild(self.bitmap_idle)	
	self:addChild(self.bitmap_fire)	
	self.gun:setRotation(self:getRotation() - 90)
	self.gun:setPosition(self:getPosition())
	self.gun:fire()
	self.timer:start()
	sounds.play(self.sound)
end

function Police:update(targetX,targetY)
	self.body:setPosition(self:getPosition())
	self:turnTo(self.targetX,self.targetY)
	self:setY(self:getY() + self.speed)
	self.fireRateCounter = self.fireRateCounter + 1
	if(self.fireRateCounter > self.fireRate) then
		self.fireRateCounter = 0
		self:fire()
	end
end

function Police:reset()
	--self:setAlpha(0)
	self:setPosition(-100,-100)
	self.body:setPosition(self:getPosition())
end