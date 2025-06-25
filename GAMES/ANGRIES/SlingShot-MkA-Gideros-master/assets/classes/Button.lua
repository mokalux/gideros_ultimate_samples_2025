Button = Core.class(Sprite)

function Button:init(sprite)
	self.focus = false
	self:addChild(sprite)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
end

function Button:onMouseUp(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		local clickEvent = Event.new("click")
		self:dispatchEvent(clickEvent)
	end
end

function Button:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) then
		self.focus = true
		event:stopPropagation()
		self.startX = self:getX()
		self.startY = self:getY()
		local clickEvent = Event.new("down")
		self:dispatchEvent(clickEvent)
	end
end

function Button:onMouseMove(event)
	if self.focus == true then
		if not self:hitTestPoint(event.x, event.y) then
			event:stopPropagation()
			local clickEvent = Event.new("move")
			self:dispatchEvent(clickEvent)	
		end
	end
end