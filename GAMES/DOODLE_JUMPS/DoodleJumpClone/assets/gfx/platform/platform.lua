GCplatform = Core.class(Bitmap)

local mRandom = math.random
local newPlatform = GCplatform.new
local b2PolygonShape = b2.PolygonShape
local b2STATIC_BODY = b2.STATIC_BODY

function GCplatform:init(texture, yPos, distance, parent)
	self.texture = texture
	self:setAnchorPoint(0.5, 0.5)
	self:setPosition(mRandom(20, 300), yPos)
	parent:addChild(self)

	self.distance = distance + 0.25
	if self.distance > 100 then
		self.distance = 100
	end

	self.body = b2World:createBody { type = b2STATIC_BODY }
	self.body:setPosition(self:getPosition())
	local blockShape = b2PolygonShape.new()
	blockShape:setAsBox(self:getWidth() * 0.5, self:getHeight() * 0.5)
	self.body:createFixture { shape = blockShape, friction = 0, restitution = 0, density = 10, isSensor = true }

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function GCplatform:onEnterFrame()
	self.body:setPosition(self:getPosition())
	local selfX, selfY = self:getParent():localToGlobal(self:getPosition())
	if not self.created then
		if selfY > 8 then
			newPlatform(self.texture, self:getY() - self.distance, self.distance, self:getParent())
			self.created = true
		end
	else
		if selfY > 488 then
			self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
			self:getParent():removeChild(self)
		end
	end
end
