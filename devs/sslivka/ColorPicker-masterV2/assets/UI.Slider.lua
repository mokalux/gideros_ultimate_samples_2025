-- UI Slider class by GeoCode, slightly modified (added event casting and range settings. pie)

Slider = Core.class( Sprite )

function Slider:init( slit, knob , dispatchEvents, rangemin, rangemax ) 
	self.slit = slit
	self.width = self.slit:getWidth()
	self:addChild( self.slit )
	self.knob = knob
	self:addChild( self.knob )
	
	self.value = 0
	
	--set default range
	if rangemin then 
	self.RangeMin = rangemin 
	else self.RangeMin = 0 end
	
	if rangemax then 
	self.RangeMax = rangemax 
	else self.RangeMax = 100 end
	
	
	self.isFocus = false
	
	self.events = dispatchEvents --if true dispatch "update"
	
	self:addEventListener( Event.MOUSE_DOWN, self.onMouseDown, self )
	self:addEventListener( Event.MOUSE_MOVE, self.onMouseMove, self )
	self:addEventListener( Event.MOUSE_UP, self.onMouseUp, self )
end

function Slider:onMouseDown( event )
	if self.knob:hitTestPoint( event.x, event.y ) then
		self.isFocus = true
		self.x0 = event.x
		event:stopPropagation()
		self.prevValue = self.value
	end
end

function Slider:onMouseMove( event )	
	if self.isFocus then
		local dx = event.x - self.x0
		self.knob:setX( self.knob:getX() + dx )
		self.x0 = event.x
		
		-- keep the knob position within its range
		if self.knob:getX() < self.RangeMin then self.knob:setX(self.RangeMin) end
		if self.knob:getX() > self.width then self.knob:setX(self.width) end
		self.value = math.floor( math.abs(self.RangeMax -self.RangeMin) * self.knob:getX() / self.width )
			
		event:stopPropagation()
	end
end

function Slider:onMouseUp( event )
	if self.isFocus then
		self.isFocus = false	
		event:stopPropagation()
		if self.prevValue ~= self.value and self.events then --dispatch "update" and optional value
			local upEvent = Event.new("update")
			--upEvent.value = self.value
			self:dispatchEvent(upEvent)
		end
	end
end

function Slider:setValue( value )
	local value = math.floor( value )
	-- check within a range of [0, 100]
	if value < self.RangeMin then value = self.RangeMin  end
	if value > self.RangeMax then value = self.RangeMax end
	posX = self.width * value / math.abs(self.RangeMax -self.RangeMin)
	self.knob:setPosition( posX, 0 )
	print("value", value, self.value)
	self.value = value
end

function Slider:getValue()
	return self.value
end
