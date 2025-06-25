local PolarObject = Core.class(Sprite)

-- all angle measures are in radians
function PolarObject:init(radius, angle, velocity)
	-- Polar coordinates
	self.polarAngle  = utils.setDefaultIfNil(angle,  0)
	self.polarRadius = utils.setDefaultIfNil(radius, 1)
	self:setVelocity(velocity)
	
	self.currentPolarRadius = self.polarRadius
	self.lineSwitchSpeed = 0

	self.timeAlive = 0

	self.type = ""
end

function PolarObject:setVelocity(velocity)
	if not velocity then 
		self.angularVelocity = 0
		return 
	end
	self.velocity = velocity
	self.angularVelocity = self.velocity / self.polarRadius
end

function PolarObject:setTexture(texture)
	if not texture then
		return
	end
	if self.bmp then 
		self.bmp:setTexture(texture)
	else 
		self.bmp = Bitmap.new(texture)
		self:addChild(self.bmp)
	end
	self.bmp:setAnchorPoint(0.5, 0.5)
	self.radius = self.bmp:getWidth() / 2
end

function PolarObject:update(deltaTime)
	self.polarAngle = utils.wrapAngle(self.polarAngle  +  self.angularVelocity * deltaTime)

	self:setX((self.currentPolarRadius) * math.cos(self.polarAngle))
	self:setY((self.currentPolarRadius) * math.sin(self.polarAngle))

	self.timeAlive = self.timeAlive + deltaTime
end

function PolarObject:setRadius(radius)
	radius = utils.setDefaultIfNil(radius, self.polarRadius)
	if (radius < 1) then
		radius = 1
	end
	self.polarRadius = radius
	-- Update angular velocity
	self:setVelocity(self.velocity)
end

function PolarObject:hitTestObject(obj)
	if not obj then
		print("Object given to hitTest is nil")
		return false
	end
	
	--[[if not (self.polarRadius == obj.polarRadius) then
		return false
	end]]

	local dx = (obj:getX() - self:getX())
	local dy = (obj:getY() - self:getY())
	local minDistance = self.radius + obj.radius
	local distance2 = dx * dx + dy * dy
	if dx * dx + dy * dy <= minDistance * minDistance then 
		return true, distance2
	else 
		return false, distance2
	end
end

return PolarObject