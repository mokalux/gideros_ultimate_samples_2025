require "tntCollision"
local qSin = math.sin
local qCos = math.cos
local checkCollision = tntCollision.pointToBox
TTestObject = Core.class(Sprite)

function TTestObject:init(newSprite)
	self.m = math.random(1, 360)
	
	repeat
		self.xPos = math.random(10, 310)
		self.yPos = math.random(10, 470)
		self.oldx = self.xPos
		self.oldy = self.yPos
	until ((self.xPos < 90) or (self.xPos > 230)) and ((self.yPos < 180) or (self.yPos > 300))
	
	self.directionX = math.random(-80, 80)
	self.directionY = math.random(-80, 80)
	
	newSprite:setAnchorPoint(anchorPointX, anchorPointY)

	self.width = newSprite:getWidth()
	self.height = newSprite:getHeight()


	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
	self:addChild(newSprite)
end


function TTestObject:onEnterFrame(event)
	self.oldx = self.xPos
	self.oldy = self.yPos

	self.xPos = self.xPos + ((self.directionX)*event.deltaTime)
	self.yPos = self.yPos + ((self.directionY)*event.deltaTime) 
	
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
	
	if checkCollision(self.xPos, self.yPos, 160, 240, 46*3, 40*3) then		
		self.directionX = self.directionX * -1
		self.directionY = self.directionY * -1
		self.xPos = self.oldx 
		self.yPos = self.oldy 
	end
	
	self:setPosition(self.xPos, self.yPos)
end
