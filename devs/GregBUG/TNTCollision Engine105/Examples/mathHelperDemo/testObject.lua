
require "tntCollision"

local qSin = math.sin
local qCos = math.cos
local getDir = tntCollision.getDirection
local qLerp = tntCollision.lerp;
local qAbs = math.abs;
local angleDiff = tntCollision.getAngleDifference
TTestObject = Core.class(Sprite)

function TTestObject:init(newSprite)
	self.angle = 0;
	self.newAngle = 0;
	self.lerping = false;
	self.xPos = application:getLogicalWidth()/2;
	self.yPos = application:getLogicalHeight()/2;
	newSprite:setAnchorPoint(anchorPointX, anchorPointY)
	
	self.width = newSprite:getWidth()
	self.height = newSprite:getHeight()
	
	
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self:addChild(newSprite)
end

function TTestObject:onMouseDown(event)
	self.newAngle = getDir(self.xPos, self.yPos, event.x, event.y);
	if qAbs(self.newAngle - self.angle) > 20 then
		self.lerping = true;
		event:stopPropagation()
	end
end

function TTestObject:onMouseMove(event)
	if not self.lerping then	
		self.newAngle = getDir(self.xPos, self.yPos, event.x, event.y);
		event:stopPropagation()
	end	
end

function TTestObject:onMouseUp(event)
end

function TTestObject:onEnterFrame(event)
	if self.newAngle ~= self.angle then
		if self.lerping then 
			self.angle = qLerp(self.angle, self.newAngle, 0.2);
			--print("lerping...");
		else
			self.angle = self.newAngle;
			--print("move to new angle...");
		end;
		if qAbs(self.newAngle - self.angle) < .1 then
			self.angle = self.newAngle;
			self.lerping = false;
		end
	end
	self:setRotation(self.angle);
end
