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

--[[
	GTween class allows to animate Gideros objects like Sprite, and everything inherited from Sprites.

	So what can you tween:
	----------------------

	x position
	y position
	alpha value
	scaleX ratio
	scaleY ratio
	rotation degrees
	
	Additional options:
	---------------------
	
	delay - delay tweening for specified amount of second or frames (default: 0)
	ease - easing from easing.lua (default: linear)
	repeatCount - how many times to repeat animation (default: 1)
	reflect - reverse animation back (default: false)
	autoPlay - automatically start animation (default: true)
	swapValues -  use provided values as starting ones and existing values as target values(default: false)
	timeScale - ratio of speed of animation (default: 1)
	useFrames - bool, use frames instead of seconds for tween duration
	dispatchEvents - dispatch tween event (default: false)
	possible events:
	init - initialization 
	change - each time values are changed 
	complete - when animation completes
	
	Here is an example of using GTween class:
	-----------------------------------------
	
	--define what to animate
	local animate = {}
	animate.y = 100
	animate.x = 100
	animate.alpha = 0.5
	animate.scaleX = 0.5
	animate.scaleY = 0.5
	animate.rotation = random(0, 360)
	 
	--define GTween properties
	local properties = {}
	properties.delay = 0	 -- wait until start gtween
	properties.ease = easing.inElastic
	properties.dispatchEvents = true
	 
	--animate them
	--- First argument: sprite to animate
	--- Second argument: duration of animation in seconds or frames
	--- Third argument: properties to animate
	--- Fourth argument: GTween properties
	local tween = GTween.new(sprite, 10, animate, properties)
	 
	--adding event on animaiton complete
	tween:addEventListener("complete", function()
		stage:removeChild(sprite)
		sprite = nil
	end)
	
	
	GTween class also provides some methods to manage tween animation:
	-------------------------------------------------------------------

	GTween:isPaused() -  check is tween is paused
	GTween:setPaused(value) - true or false to pause/unpause
	GTween:getPosition() - position of animation (time span) from -delay to repeatCount*duration
	GTween:setPosition(value) - jump to specified position of animation
	GTween:getDelay() - get delay value
	GTween:setDelay(value) -  set delay in seconds or frames
	GTween:setValue(name, value) -  change animation value, example setValue("alpha", 1)
	GTween:getValue(name) -  get end value for specified property
	GTween:deleteValue(name) - delete value, so it won't be animated
	GTween:setValues(values) - set values to animate
	GTween:resetValues(values) - resets previous animation values and sets new ones
	GTween:getValues() - returns table with animation values
	GTween:getInitValue(name) - returns initial value of specified property
	GTween:swapValues() - make existing animation values as target values and start animation from provided animation values
	GTween:toBeginning() - go to beggining of animation and pause it
	GTween:toEnd() - go to the end of animation
	
	GTween.pauseAll = true or false stop all GTween
	Bonus content: You can use easing for GTween animations using easing.lua and here are the easing options:
	----------------------------------------------------------------------------------------------------------

	easing.inBack		-- funny Winki Aircraft
	easing.outBack		-- Nice
	easing.inOutBack
	
	easing.inBounce
	easing.outBounce	-- maybe
	easing.inOutBounce
	
	easing.inCircular
	easing.outCircular
	easing.inOutCircular
	
	easing.inCubic
	easing.outCubic  -- Nice
	easing.inOutCubic
	
	easing.inElastic
	easing.outElastic -- Nice
	easing.inOutElastic
	
	easing.inExponential
	easing.outExponential
	easing.inOutExponential
	
	easing.linear
	
	easing.inQuadratic
	easing.outQuadratic
	easing.inOutQuadratic
	
	easing.inQuartic
	easing.outQuartic
	easing.inOutQuartic
	
	easing.inQuintic
	easing.outQuintic
	easing.inOutQuintic
	
	easing.inSine
	easing.outSine
	easing.inOutSine -- Nice
	
	additional examples (thanks to Atilim )
	----------------------------------------------------------------------------------------------
	And here is the correct way to chain tweens:
	local tween1 = GTween.new(sprite, 1, {x = 240}, {})
	local tween2 = GTween.new(sprite, 1, {y = 100}, {autoPlay = false})
	local tween3 = GTween.new(sprite, 1, {alpha = 0}, {autoPlay = false})
	tween1.nextTween = tween2
	tween2.nextTween = tween3
	
	Also this is same:
	local tween3 = GTween.new(sprite, 1, {alpha = 0}, {autoPlay = false})
	local tween2 = GTween.new(sprite, 1, {y = 100}, {autoPlay = false, nextTween = tween3})
	local tween1 = GTween.new(sprite, 1, {x = 240}, {nextTween = tween2})
	
	
- See more at: http://appcodingeasy.com/Gideros-Mobile/Gideros-GTween-with-easing#sthash.vVpOetO7.dpuf
]]

---------------------------
-- math functions
---------------------------
local log = math.log
local floor = math.floor
---------------------------


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
	self._position = log(-1)	-- NaN
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
		if self.reflect and floor(self:getPosition() / self.duration) % 2 ~= 0 then
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