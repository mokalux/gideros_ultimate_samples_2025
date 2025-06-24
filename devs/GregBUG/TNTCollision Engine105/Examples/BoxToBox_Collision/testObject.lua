
local qSin = math.sin
local qCos = math.cos

TTestObject = Core.class(Sprite)

function TTestObject:init(newSprite)
	self.xPos = 0
	self.yPos = 0
	newSprite:setAnchorPoint(anchorPointX, anchorPointY)
	
	self.width = newSprite:getWidth()
	self.height = newSprite:getHeight()
	
	self:setPosition(self.xPos, self.yPos)
	
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self:addChild(newSprite)
end

function TTestObject:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.x0 = event.x
		self.y0 = event.y
		
		self.xPos = self:getX()
		self.yPos = self:getY()	
		
		self.isFocus = true
		event:stopPropagation()
	end
end

function TTestObject:onMouseMove(event)
	if self.isFocus then
		local dx = event.x - self.x0
		local dy = event.y - self.y0	
		
		self.xPos = self.xPos + dx
		self.yPos = self.yPos + dy			
				
		self:setX(self.xPos)
		self:setY(self.yPos)
		
		self.x0 = event.x
		self.y0 = event.y
		event:stopPropagation()
	end
end

function TTestObject:onMouseUp(event)
	if self.isFocus then
		self.xPos = self:getX()
		self.yPos = self:getY()	
		self.isFocus = false	
		event:stopPropagation()
	end
end

function TTestObject:onEnterFrame(event)
	self:setPosition(self.xPos, self.yPos)
	self.inCollision = false
end
