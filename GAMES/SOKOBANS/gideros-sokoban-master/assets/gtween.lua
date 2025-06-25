--[[
GTween for Gideros
This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
Copyright (c) 2010 - 2011 Gideros Mobile 

Based on GTween 2.01 for ActionScript 3
http://gskinner.com/libraries/gtween/
GTween 2.01 for ActionScript 3 is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
Copyright (c) 2009 Grant Skinner

Notes:
* Documentation is derived from GTween 2.01's original documentation.
* Plugins, GTweenTimeline and proxy objects are not supported.
]]

--[[
	* GTween is a light-weight instance oriented tween engine. This means that you instantiate tweens for specific purposes, and then reuse, update or discard them.
	* This is different than centralized tween engines where you "register" tweens with a global object. This provides a more familiar and useful interface
	* for object oriented programmers.

	* GTween boasts a number of advanced features:
	* - frame and time based durations/positions which can be set per tween
	* - simple sequenced tweens using .nextTween
	* - pause and resume individual tweens or all tweens
	* - jump directly to the end or beginning of a tween with :toEnd() or :toBeginning()
	* - jump to any arbitrary point in the tween with :setPosition()
	* - complete, init, and change callbacks
	* - smart garbage collector interactions (prevents collection while active, allows collection if target is collected)
	* - easy to set up in a single line of code
	* - can repeat or reflect a tween a specified number of times
	* - deterministic, so setting a position on a tween will (almost) always result in predictable results
]]

GTween = gideros.class(EventDispatcher)

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

GTween.defaultDispatchEvents = true
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

--[[
	* Constructs a new GTween instance.
	*
	* target: The object whose properties will be tweened.
	* duration: The length of the tween in frames or seconds depending on the timingMode.
	* values: An object containing end property values. For example, to tween to x=100, y=100, you could pass {x=100, y=100} as the values object.
	* props: An object containing properties to set on this tween. For example, you could pass {ease=myEase} to set the ease property of the new instance. It also supports a single special property "swapValues" that will cause :swapValues() to be called after the values specified in the values parameter are set.
]]
function GTween:init(target, duration, values, props)
	self._delay = 0
	self._paused = true
	self._position = math.log(-1)	-- NaN
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

--[[
	* Plays or pauses a tween. You can still change the position value externally on a paused
	* tween, but it will not be updated automatically. While paused is false, the tween is also prevented
	* from being garbage collected while it is active.
	* This is achieved in one of two ways:
	* 1. If the target object derives from EventDispatcher, then the tween will subscribe to a dummy event using a hard reference. This allows
	* the tween to be garbage collected if its target is also collected, and there are no other external references to it.
	* 2. If the target object is not an EventDispatcher, then the tween is placed in a global list, to prevent collection until it is paused or completes.
	* Note that pausing all tweens via the GTween.pauseAll static property will not free the tweens for collection.
]]
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
			-- reached the end, reset.
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


--[[
	* Gets and sets the position of the tween in frames or seconds (depending on .useFrames). This value will
	* be constrained between -delay and repeatCount*duration. It will be resolved to a .calculatedPosition before
	* being applied.
	*
	* Negative values:
	* Values below 0 will always resolve to a calculatedPosition of 0. Negative values can be used to set up a delay on the tween, as the tween will have to count up to 0 before initing.
	*
	* Positive values:
	* Positive values are resolved based on the duration, repeatCount, and reflect properties.
]]
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


--[[
	* The length of the delay in frames or seconds (depending on .useFrames).
	* The delay occurs before a tween reads initial values or starts playing.
]]
function GTween:getDelay()
	return self._delay
end

function GTween:setDelay(value)
	if self._position <= 0 then
		self._position = -value;
	end
	self._delay = value;
end


--[[
	* Sets the numeric end value for a property on the target object that you would like to tween.
	* For example, if you wanted to tween to a new x position, you could use: myGTween:setValue("x",400).
	*
	* name: The name of the property to tween.
	* value: The numeric end value (the value to tween to).
]]
function GTween:setValue(name, value)
	self._values[name] = value
	self:invalidate()
end

--[[
	* Returns the end value for the specified property if one exists.
	*
	* name: The name of the property to return a end value for.
]]
function GTween:getValue(name)
	return self._values[name]
end

--[[
	* Removes a end value from the tween. This prevents the GTween instance from tweening the property.
	*
	* name: The name of the end property to delete.
]]
function GTween:deleteValue(name)
	self._rangeValues[name] = nil
	self._initValues[name] = nil
	local result = self._values[name] ~= nil
	self._values[name] = nil
	return result
end


--[[
	* Shorthand method for making multiple setProperty calls quickly.
	* This adds the specified properties to the values list.
	* 
	* Example: set x and y end values:
	* myGTween:setProperties({x=200, y=400})
	*
	* properties: An object containing end property values.
]]
function GTween:setValues(values)
	copy(values, self._values, true)
	self:invalidate()
end

--[[
	* Similar to :setValues(), but clears all previous end values
	* before setting the new ones.
	*
	* properties: An object containing end property values.
]]
function GTween:resetValues(values)
	self._values = {}
	self:setValues(values)
end

--[[
	* Returns the table of all end properties and their values. This is a copy of values, so modifying
	* the returned object will not affect the tween.
]]
function GTween:getValues()
	return copy(self._values, {})
end

--[[
	* Returns the initial value for the specified property.
	* Note that the value will not be available until the tween inits.
]]
function GTween:getInitValue(name)
	return self._initValues[name]
end

--[[
	* Swaps the init and end values for the tween, effectively reversing it.
	* This should generally only be called before the tween starts playing.
	* This will force the tween to init if it hasn't already done so, which
	* may result in an onInit call.
	* It will also force a render (so the target immediately jumps to the new values
	* immediately) which will result in the onChange callback being called.
	* 
	* You can also use the special "swapValues" property on the props parameter of
	* the GTween constructor to call :swapValues() after the values are set.
	* 
	* The following example would tween the target from 100,100 to its current position:
	* GTween.new(ball, 2, {x=100, y=100}, {swapValues=true})
]]
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

--[[
	* Reads all of the initial values from target and calls the onInit callback.
	* This is called automatically when a tween becomes active (finishes delaying)
	* and when :swapValues() is called. It would rarely be used directly
	* but is exposed for possible use by power users.
]]
function GTween:init2()
	self._inited = true
	self._initValues = {}
	self._rangeValues = {}

	for n in pairs(self._values) do
		self._initValues[n] = self.target:get(n)
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

--[[
	* Jumps the tween to its beginning and pauses it. This is the same as calling :setPosition(0) and :setPaused(true).
]]
function GTween:toBeginning()
	self:setPosition(0)
	self:setPaused(true)
end

--[[
	* Jumps the tween to its end and pauses it. This is roughly the same as calling :setPosition(repeatCount*duration).
]]
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

--[[
Author of this easing functions for Lua is Josh Tynjala
https://github.com/joshtynjala/gtween.lua
Licensed under the MIT license.

Easing functions adapted from Robert Penner's AS3 tweening equations.
]]

local backS = 0 -- 1.70158
easing = {};
easing.inBack = function(ratio)
	return ratio*ratio*((backS+1)*ratio-backS)
end
easing.outBack = function(ratio)
	ratio = ratio - 1
	return ratio*ratio*((backS+1)*ratio+backS)+1
end
easing.inOutBack = function(ratio)
	ratio = ratio * 2
	if ratio < 1 then
		return 0.5*(ratio*ratio*((backS*1.525+1)*ratio-backS*1.525))
	else 
		ratio = ratio - 2
		return 0.5*(ratio*ratio*((backS*1.525+1)*ratio+backS*1.525)+2)
	end
end
easing.inBounce = function(ratio)
	return 1-easing.outBounce(1-ratio,0,0,0)
end
easing.outBounce = function(ratio)
	if ratio < 1/2.75 then
		return 7.5625*ratio*ratio
	elseif ratio < 2/2.75 then
		ratio = ratio - 1.5/2.75
		return 7.5625*ratio*ratio+0.75
	elseif ratio < 2.5/2.75 then
		ratio= ratio - 2.25/2.75
		return 7.5625*ratio*ratio+0.9375
	else
		ratio = ratio - 2.625/2.75
		return 7.5625*ratio*ratio+0.984375
	end
end
easing.inOutBounce = function(ratio)
	ratio = ratio * 2
	if ratio < 1 then 
		return 0.5*easing.inBounce(ratio,0,0,0)
	else
		return 0.5*easing.outBounce(ratio-1,0,0,0)+0.5
	end
end
easing.inCircular = function(ratio)
	return -(math.sqrt(1-ratio*ratio)-1)
end
easing.outCircular = function(ratio)
	return math.sqrt(1-(ratio-1)*(ratio-1))
end
easing.inOutCircular = function(ratio)
	ratio = ratio * 2
	if ratio < 1 then
		return -0.5*(math.sqrt(1-ratio*ratio)-1)
	else
		ratio = ratio - 2
		return 0.5*(math.sqrt(1-ratio*ratio)+1)
	end
end
easing.inCubic = function(ratio)
	return ratio*ratio*ratio
end
easing.outCubic = function(ratio)
	ratio = ratio - 1
	return ratio*ratio*ratio+1
end
easing.inOutCubic = function(ratio)
	if ratio < 0.5 then
		return 4*ratio*ratio*ratio
	else
		ratio = ratio - 1
		return 4*ratio*ratio*ratio+1
	end
end
local elasticA = 1;
local elasticP = 0.3;
local elasticS = elasticP/4;
easing.inElastic = function(ratio)
	if ratio == 0 or ratio == 1 then
		return ratio
	end
	ratio = ratio - 1
	return -(elasticA * math.pow(2, 10 * ratio) * math.sin((ratio - elasticS) * (2 * math.pi) / elasticP));
end
easing.outElastic = function(ratio)
	if ratio == 0 or ratio == 1 then
		return ratio
	end
	return elasticA * math.pow(2, -10 * ratio) *  math.sin((ratio - elasticS) * (2 * math.pi) / elasticP) + 1;
end
easing.inOutElastic = function(ratio)
	if ratio == 0 or ratio == 1 then
		return ratio
	end
	ratio = ratio*2-1
	if ratio < 0 then
		return -0.5 * (elasticA * math.pow(2, 10 * ratio) * math.sin((ratio - elasticS*1.5) * (2 * math.pi) /(elasticP*1.5)));
	end
	return 0.5 * elasticA * math.pow(2, -10 * ratio) * math.sin((ratio - elasticS*1.5) * (2 * math.pi) / (elasticP*1.5)) + 1;
end
easing.inExponential = function(ratio)
	if ratio == 0 then
		return 0
	end
	return math.pow(2, 10 * (ratio - 1))
end
easing.outExponential = function(ratio)
	if ratio == 1 then
		return 1
	end
	return 1-math.pow(2, -10 * ratio)
end
easing.inOutExponential = function(ratio)
	if ratio == 0 or ratio == 1 then 
		return ratio
	end
	ratio = ratio*2-1
	if 0 > ratio then
		return 0.5*math.pow(2, 10*ratio)
	end
	return 1-0.5*math.pow(2, -10*ratio)
end
easing.linear = function(ratio)
	return ratio
end
easing.inQuadratic = function(ratio)
	return ratio*ratio
end
easing.outQuadratic = function(ratio)
	return -ratio*(ratio-2)
end
easing.inOutQuadratic = function(ratio)
	if ratio < 0.5 then
		return 2*ratio*ratio
	end
	return -2*ratio*(ratio-2)-1
end
easing.inQuartic = function(ratio)
	return ratio*ratio*ratio*ratio
end
easing.outQuartic = function(ratio)
	ratio = ratio - 1
	return 1-ratio*ratio*ratio*ratio
end
easing.inOutQuartic = function(ratio)
	if ratio < 0.5 then
		return 8*ratio*ratio*ratio*ratio
	end
	ratio = ratio - 1
	return -8*ratio*ratio*ratio*ratio+1
end
easing.inQuintic = function(ratio)
	return ratio*ratio*ratio*ratio*ratio
end
easing.outQuintic = function(ratio)
	ratio = ratio - 1
	return 1+ratio*ratio*ratio*ratio*ratio
end
easing.inOutQuintic = function(ratio)
	if ratio < 0.5 then
		return 16*ratio*ratio*ratio*ratio*ratio
	end
	ratio = ratio - 1
	return 16*ratio*ratio*ratio*ratio*ratio+1
end
easing.inSine = function(ratio)
	return 1-math.cos(ratio * (math.pi / 2))
end
easing.outSine = function(ratio)
	return math.sin(ratio * (math.pi / 2))
end
easing.inOutSine = function(ratio)
	return -0.5*(math.cos(ratio*math.pi)-1)
end