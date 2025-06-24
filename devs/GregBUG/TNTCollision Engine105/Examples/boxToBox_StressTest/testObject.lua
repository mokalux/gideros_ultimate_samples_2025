
local qSin = math.sin
local qCos = math.cos

TTestObject = Core.class(Sprite)

function TTestObject:init(newSprite)
	self.m = math.random(1, 360)
	self.inCollision = false
	
	self.xPos = math.random(50, 270)
	self.yPos = math.random(50, 430)
	
	self.xScale = 1
	self.yScale = 1
	
	self.directionX = math.random(-80, 80)
	self.directionY = math.random(-80, 80)
	
	newSprite:setAnchorPoint(anchorPointX, anchorPointY)

	self.width = newSprite:getWidth()
	self.height = newSprite:getHeight()


	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
	self:addChild(newSprite)
end


function TTestObject:onEnterFrame(event)
	self.xPos = self.xPos + (self.directionX*event.deltaTime)
	self.yPos = self.yPos + (self.directionY*event.deltaTime) 
	
	if self.xPos  > 320 + self.width  then 
		self.xPos = -self.width 
	elseif self.xPos < -self.width  then 
		self.xPos = 320 + self.width 
	end
	if self.yPos > 480 +self.height  then 
		self.yPos = -self.height
	elseif self.yPos < -self.height then 
		self.yPos = 480 + self.height
	end
	
	if self.inCollision then
		self:setAlpha(0.3)
	else
		self:setAlpha(1)
	end	
	
	self.xScale = 1+qSin(self.m)/7
	self.yScale = 1+qSin(self.m)/7
	
	self:setScale(self.xScale, self.yScale)
	self.m = self.m + (10 *  event.deltaTime)
	
	self:setPosition(self.xPos, self.yPos)
	self.inCollision = false
end
