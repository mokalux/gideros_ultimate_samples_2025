GCchar = Core.class(Bitmap)

function GCchar:init()
	self:setAnchorPoint(0.5, 0.5)
	self:setPosition(160, 492)

	self.body = b2World:createBody { type = b2.DYNAMIC_BODY }
	self.body:setPosition(self:getPosition())

	local blockShape = b2.PolygonShape.new()
	blockShape:setAsBox(self:getWidth() * 0.5, self:getHeight() * 0.5)
	self.body:createFixture{shape = blockShape, friction = 0, restitution = 0, density = 10, isSensor = false }
	self.body:setLinearVelocity(0, -13)

	b2World:addEventListener(Event.BEGIN_CONTACT, self.onBeginCollision, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function GCchar:onEnterFrame()
	b2World:step(1/60, 8, 3)
	self:getParent():addChild(self)

	self:setPosition(self.body:getPosition())
	local selfX, selfY = self:getParent():localToGlobal(self:getPosition())
	if selfY < 240 then
		self:getParent():setY(240 - self:getY())
	end
	if selfX < 0 then
		local bodyX, bodyY = self.body:getPosition()
		self.body:setPosition(320, bodyY)
	elseif selfX > 320 then
		local bodyX, bodyY = self.body:getPosition()
		self.body:setPosition(0, bodyY)
	end
end

function GCchar:onBeginCollision(event)
	local bodyA, bodyB = event.fixtureA:getBody(), event.fixtureB:getBody()
	if bodyA == self.body or bodyB == self.body then
		local xSpeed, ySpeed = self.body:getLinearVelocity()
		if ySpeed > 0 then
			self.body:setLinearVelocity(xSpeed, -13)
		end
	end
end

function GCchar:onMouseDown(event)
	local xSpeed, ySpeed = self.body:getLinearVelocity()
	if event.x < 160 then
		self.body:setLinearVelocity(-4, ySpeed)
	else
		self.body:setLinearVelocity(4, ySpeed)
	end
	event:stopPropagation()
end

function GCchar:onMouseUp(event)
	local xSpeed, ySpeed = self.body:getLinearVelocity()
	self.body:setLinearVelocity(0, ySpeed)
	event:stopPropagation()
end
