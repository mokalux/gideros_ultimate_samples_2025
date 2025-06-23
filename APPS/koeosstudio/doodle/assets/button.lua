Button = Core.class(Sprite)

function Button:init(gfx)
	self.acceptControl = true
	self.touchId = 0
	
	self.startEvent = Event.new('start')
	self.endEvent = Event.new('end')
	self.clickEvent = Event.new('click')
	
	self.gfx = gfx
	self:addChild(self.gfx[1])
	
	if #self.gfx == 2 then
		self:addChild(self.gfx[2])
		self.gfx[2]:setAlpha(0)
	end
	
	self:setAnchorPoint(0.5, 0.5)	
		
	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
end


function Button:onTouchesBegin(event)
	if self:hitTestPoint(event.touch.x, event.touch.y) and self.touchId == 0 then
		self.touchId = event.touch.id
		
		self:setScale(0.9)
		self:setGfx(2)
		
		self:dispatchEvent(self.startEvent)
		event:stopPropagation()
	end
end

function Button:onTouchesEnd(event)
	if self:hitTestPoint(event.touch.x, event.touch.y) and self.touchId == event.touch.id then
		self.touchId = 0
		self:setScale(1)
		self:setGfx(1)
		
		self:dispatchEvent(self.clickEvent)
		event:stopPropagation()
	elseif self.touchId == event.touch.id then
		self.touchId = 0
		self:setScale(1)
		self:setGfx(1)
		
		self:dispatchEvent(self.endEvent)
		event:stopPropagation()
	end
end

function Button:setGfx(index)
	if index == 1 and #self.gfx == 2 then
		self.gfx[1]:setAlpha(1)
		self.gfx[2]:setAlpha(0)
	elseif index == 2 and #self.gfx == 2 then
		self.gfx[1]:setAlpha(0)
		self.gfx[2]:setAlpha(1)	
	end
end
