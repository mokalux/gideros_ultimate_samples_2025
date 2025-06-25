-- UI Slider class
Slider = Core.class(Sprite)

function Slider:init(slit, knob)
	self.slit = slit
	self.width = self.slit:getWidth()
	self:addChild(self.slit)

	self.knob = knob
	self:addChild(self.knob)

	self.value = 0
	self.isFocus = false

	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function Slider:onMouseDown(event)
	if self.knob:hitTestPoint(event.x, event.y) then
		self.isFocus = true
		self.x0 = event.x
		event:stopPropagation()
	end
end

function Slider:onMouseMove(event)
	if self.isFocus then
		local dx = event.x - self.x0
		self.knob:setX(self.knob:getX() + dx)
		self.x0 = event.x
		
		-- keep the knob position within its range
		if self.knob:getX() < 0 then self.knob:setX(0) end
		if self.knob:getX() > self.width then self.knob:setX(self.width) end
		self.value = math.floor(100 * self.knob:getX() / self.width)
		event:stopPropagation()
	end
end

function Slider:onMouseUp(event)
	if self.isFocus then
		self.isFocus = false
		event:stopPropagation()
	end
end

function Slider:setValue(value)
	local value = math.floor(value)
	-- check within a range of [0, 100]
	if value < 0 then value = 0 end
	if value > 100 then value = 100 end
	posX = self.width * value / 100
	self.knob:setPosition(posX, 0)
	self.value = value
end

function Slider:getValue()
	return self.value
end
