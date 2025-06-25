

GTween = Core.class(EventDispatcher)

function GTween.linearEase(a, b, c, d)
	return a
end

local function copy(o1, o2)
	if o1 ~= nil then
		for n,v in pairs(o1) do
			local setter = o2._setters and o2._setters[n]
			if setter ~= nil then
				setter(o2, v)
			else
				o2[n] = v
			end
		end
	end
	return o2
end

local function isNaN(z)
	return z ~= z
end
	
GTween.defaultDispatchEvents = false
GTween.defaultEase = GTween.linearEase
GTween.pauseAll = false
GTween.timeScaleAll = 1

GTween.tickList = setmetatable({}, {__mode="k"})
GTween.tempTickList = {}
GTween.gcLockList = {}

function GTween.staticInit()
	GTween.shape = Shape.new()
	GTween.shape:addEventListener(Event.ENTER_FRAME, GTween.staticTick)
	GTween.time = os.timer()
end

function GTween.staticTick()
	local t = GTween.time
	GTween.time = os.timer()
	if GTween.pauseAll then
		return
	end
	local dt = (GTween.time - t) * GTween.timeScaleAll
	for tween in pairs(GTween.tickList) do
		tween:setPosition(tween._position + (tween.useFrames and GTween.timeScaleAll or dt) * tween.timeScale)
	end
	for k,v in pairs(GTween.tempTickList) do
		GTween.tickList[k] = v
		GTween.tempTickList[k] = nil
	end
end


function GTween:init(target, duration, values, props)
	self._delay = 0
	self._paused = true
	self._position = math.log(-1)	
	self.autoPlay = true
	self.repeatCount = 1
	self.timeScale = 1
	
	self.ease = GTween.defaultEase
	self.dispatchEvents = GTween.defaultDispatchEvents
	self.target = target
	self.duration = duration
	
	local swap = nil
	if props then
		 swap = props.swapValues
		 props.swapValues = nil
	end
	copy(props, self)
	self:resetValues(values)
	if swap then
		self:swapValues()
	end
	if self.duration == 0 and self:getDelay() == 0 and self.autoPlay then
		self:setPosition(0)
	end
end


function GTween:isPaused()
	return self._paused
end

function GTween:setPaused(value)
	if value == self._paused then
		return
	end
	self._paused = value
	if self._paused then
		GTween.tickList[self] = nil
		GTween.tempTickList[self] = nil
		if self.target.removeEventListener ~= nil then 
			self.target:removeEventListener("_", self.invalidate, self) 
		end
		GTween.gcLockList[self] = nil
	else
		if isNaN(self._position) or (self.repeatCount ~= 0 and self._position >= self.repeatCount * self.duration) then
			
			self._inited = false;
			self.calculatedPosition = 0
			self.calculatedPositionOld = 0
			self.ratio = 0
			self.ratioOld = 0
			self.positionOld = 0
			self._position = -self:getDelay()
		end
		GTween.tempTickList[self] = true
		if self.target.addEventListener ~= nil then 
			self.target:addEventListener("_", self.invalidate, self) 
		else
			GTween.gcLockList[self] = true		
		end
	end
end

function GTween.stopAll()
	for k,v in pairs(GTween.tempTickList) do
		GTween.tickList[k] = v
		GTween.tempTickList[k] = nil
	end
	
	for k,v in pairs(GTween.tickList) do
		if k.target.removeEventListener ~= nil then 
			k.target:removeEventListener("_", k.invalidate, k)
		end
		GTween.tickList[k] = nil	
	end

	for k,v in pairs(GTween.gcLockList) do
		GTween.gcLockList[k] = nil
	end
end

function GTween:stop()
	
end

function GTween:getPosition()
	return self._position
end

function GTween:setPosition(value)
	self.positionOld = self._position
	self.ratioOld = self.ratio
	self.calculatedPositionOld = self.calculatedPosition

	local maxPosition = self.repeatCount * self.duration

	local end_ = value >= maxPosition and self.repeatCount > 0
	if end_	then
		if self.calculatedPositionOld == maxPosition then
			return
		end
		self._position = maxPosition
		self.calculatedPosition = (self.reflect and (self.repeatCount % 2 == 0)) and 0 or self.duration
	else
		self._position = value
		self.calculatedPosition = (self._position < 0) and 0 or (self._position % self.duration)
		if self.reflect and math.floor(self:getPosition() / self.duration) % 2 ~= 0 then
			self.calculatedPosition = self.duration - self.calculatedPosition
		end
	end

	self.ratio = (self.duration == 0 and self._position >= 0) and 1 or self.ease(self.calculatedPosition / self.duration, 0, 1, 1)

	if self.target and (self._position >= 0 or self.positionOld >= 0) and self.calculatedPosition ~= self.calculatedPositionOld then
		if not self._inited then
			self:init2()
		end
		for n in pairs(self._values) do
			local initVal = self._initValues[n]
			local rangeVal = self._rangeValues[n]
			local val = initVal + rangeVal * self.ratio

			self.target:set(n, val)
		end		
	end

	if not self.suppressEvents then
		if self.dispatchEvents then
			self:dispatchEvt("change")
		end
		if self.onChange ~= nil then
			self:onChange()
		end
	end
	if end_ then
		self:setPaused(true)
		if self.nextTween then
			self.nextTween:setPaused(false)
		end
		if not self.suppressEvents then
			if self.dispatchEvents then
				self:dispatchEvt("complete")
			end
			if self.onComplete ~= nil then
				self:onComplete()
			end
		end
	end
end


function GTween:getDelay()
	return self._delay
end

function GTween:setDelay(value)
	if self._position <= 0 then
		self._position = -value;
	end
	self._delay = value;
end



function GTween:setValue(name, value)
	self._values[name] = value
	self:invalidate()
end

function GTween:getValue(name)
	return self._values[name]
end

function GTween:deleteValue(name)
	self._rangeValues[name] = nil
	self._initValues[name] = nil
	local result = self._values[name] ~= nil
	self._values[name] = nil
	return result
end



function GTween:setValues(values)
	copy(values, self._values, true)
	self:invalidate()
end


function GTween:resetValues(values)
	self._values = {}
	self:setValues(values)
end


function GTween:getValues()
	return copy(self._values, {})
end

function GTween:getInitValue(name)
	return self._initValues[name]
end


function GTween:swapValues()
	if not self._inited then
		self:init2()
	end
	local o = self._values;
	self._values = self._initValues;
	self._initValues = o;
	for n,v in pairs(self._rangeValues) do
		self._rangeValues[n] = -v
	end
	if self._position < 0 then
		local pos = self.positionOld
		self:setPosition(0)
		self._position = self.positionOld
		self.positionOld = pos
	else
		self:setPosition(self._position)
	end
end

function GTween:init2()
	self._inited = true
	self._initValues = {}
	self._rangeValues = {}

	for n in pairs(self._values) do
		self._initValues[n] = self.target:get(n)
		--print(self._rangeValues[n])
		self._rangeValues[n] = self._values[n] - self._initValues[n];
	end

	if not self.suppressEvents then
		if self.dispatchEvents then
			self:dispatchEvt("init")
		end
		if self.onInit ~= nil then
			self:onInit()
		end
	end
end


function GTween:toBeginning()
	self:setPosition(0)
	self:setPaused(true)
end


function GTween:toEnd()
	self:setPosition((self.repeatCount > 0) and self.repeatCount * self.duration or self.duration)
end

function GTween:invalidate()
	self._inited = false;
	if self._position > 0 then 
		self._position = 0
	end
	if self.autoPlay then 
		self:setPaused(false)
	end
end

function GTween:dispatchEvt(name)
	if self:hasEventListener(name) then
		self:dispatchEvent(Event.new(name))
	end
end

GTween._getters = {paused = GTween.getPaused, delay = GTween.getDelay, position = GTween.getPosition}
GTween._setters = {paused = GTween.setPaused, delay = GTween.setDelay, position = GTween.setPosition}

GTween.staticInit()
