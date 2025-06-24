
local qSin = math.sin
local qCos = math.cos

TTestObject = Core.class(Sprite)

function TTestObject:init(newSprite)
	self.inCollision = false
	self.m = math.random(1, 360)
	self.directionX = math.random(-80, 80)
	self.directionY = math.random(-80, 80)
	
	newSprite:setAnchorPoint(.5, .5)

	self.width = newSprite:getWidth()
	self.height = newSprite:getHeight()
	self.scaleX = 1
	self.scaleY = 1
	self.xPos = math.random(50,270)
	self.yPos = math.random(50, 430)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self:addChild(newSprite)
end



function TTestObject:onEnterFrame(event)
	self.xPos = self.xPos + (self.directionX*event.deltaTime)
	self.yPos = self.yPos + (self.directionY*event.deltaTime) 
	
	if self.xPos  > 320 + self.width  then 
		self.xPos = -self.width 
	end
	if self.xPos < -self.width  then 
		self.xPos = 320 + self.width 
	end
	if self.yPos > 480 +self.height  then 
		self.yPos = -self.height
	end
	if self.yPos < -self.height then 
		self.yPos = 480 + self.height
	end
	if self.inCollision then
		self:setAlpha(.4)
		self:setColorTransform(255,0,0)
	else
		self:setAlpha(1)
		self:setColorTransform(255,255,255)
	end	
	self.m = self.m + (8 *  event.deltaTime)
	self.scaleX = 1.5 + qSin(self.m)/5
	self.scaleY = 1.5 + qCos(self.m)/5
	
	self:setScale(self.scaleX, self.scaleY)
	self:setRotation(self.m)
	self:setPosition(self.xPos, self.yPos)
	
	self.inCollision = false
end
