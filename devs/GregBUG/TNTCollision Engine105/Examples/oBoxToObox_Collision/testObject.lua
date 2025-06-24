
local qSin = math.sin
local qCos = math.cos

TTestObject = Core.class(Sprite)

function TTestObject:setXYScale(x, y)
	self.scaleBaseX = x
	self.scaleBaseY = y
	self.scaleX = x
	self.scaleY = y
end

function TTestObject:init(newSprite)
	self.m = 0 --math.random(1, 360)
	newSprite:setAnchorPoint(vx, vy)
	self.scaleBaseX = 1
	self.scaleBaseY = 1
	self.scaleX = 1
	self.xPos = 0
	self.m = math.random(360)
	
	self.yPos = 0
	self.scaleY = 0
	self.speed = 50
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
	self:setRotation(self.m)
	self.scaleX = self.scaleBaseX--+qSin(self.m/5)/3
	self.scaleY = self.scaleBaseY--+qCos(self.m/5)/3
	self:setScale(self.scaleX , self.scaleY)
	self.m = self.m + (20 *  event.deltaTime)
end
