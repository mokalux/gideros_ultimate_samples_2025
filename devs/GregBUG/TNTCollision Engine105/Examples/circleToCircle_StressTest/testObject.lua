
local qSin = math.sin
local qCos = math.cos

TTestObject = Core.class(Sprite)

function TTestObject:init(newSprite)
    self.xPos = 0
	self.yPos = 0
	self.xScale = 1
	self.yScale = 1
	repeat
		self.goOn = math.random(-1,1)
	until self.goOn ~= 0
	
	self.inCollision = false
	self.m = math.random(1, 360)
	self.directionX = math.random(-80, 80)
	self.directionY = math.random(-80, 80)
	
	newSprite:setAnchorPoint(.5,.5)
	self.width = newSprite:getWidth()/2
	self.height = newSprite:getHeight()/2
	
	self:setPosition(math.random(0,320), math.random(0, 480))
	
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
		self:setAlpha(.3)
		--self:setColorTransform(.2,.5,1)
	else
		self:setAlpha(1)
	--	self:setColorTransform(1,1,1)
	end	
	--self:setRotation(self.m)
	self.xScale = 1.5+qSin(self.m)/7
	self.yScale = self.xScale

	self:setScale(self.xScale, self.yScale)
	self.m = self.m + (10 *  event.deltaTime)
	self:setRotation(self.m*(20*self.goOn))
	self:setPosition(self.xPos, self.yPos)
	self.inCollision = false
end
