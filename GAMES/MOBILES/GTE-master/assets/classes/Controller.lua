require "accelerometer"

Controller = gideros.class()

local controlCanMove = false
local touchDeltaX = 0
local touchDeltaY = 0
local isDecelerating = true

function Controller:init(caller)
	self.caller = caller
	self.type = CONTROLLER_TYPE
	self.filter = 0.999
	self.fx = 0
	self.fy = 0
end

function Controller:attachController(type)
	if type == 1 then --Touch
		self.caller.control:addEventListener(Event.TOUCHES_BEGIN, self.onTouchBegin, self)
		self.caller.control:addEventListener(Event.TOUCHES_MOVE, self.onTouchMove, self)
		self.caller.control:addEventListener(Event.TOUCHES_END, self.onTouchEnd, self)
	elseif type == 2 then --Accelerometer
		accelerometer:start()
	end
end

function Controller:detachController()
	if self.type == 2 then
		accelerometer:stop()
	end
	self.type = 0
end

function Controller:onTouchBegin(event)
	isDecelerating = false
	local x = event.touch.x
	local y = event.touch.y
	
	local control = self.caller:getControl()
	local xCenter, yCenter = control:getPosition()
	
	if math.pow(x - xCenter, 2) + math.pow(y - yCenter, 2) <= math.pow(control:getWidth() / 2, 2) then
		controlCanMove = true
		touchDeltaX = x - xCenter
		touchDeltaY = y - yCenter
	else
		controlCanMove = false
	end
end

function Controller:onTouchMove(event)
	if controlCanMove then
		local x = event.touch.x
		local y = event.touch.y
		self.caller:moveControl(x - touchDeltaX, y - touchDeltaY)
	end
end

function Controller:onTouchEnd(event)
	isDecelerating = true
	controlCanMove = false
	self.caller:resetControl()
	self:movePlayer(0, 0)
end

function Controller:moveByAnalog()
	if isDecelerating then
		self:movePlayer(0, 0)
	end
end

function Controller:moveByAccelerator()
	-- get accelerometer values
	local x, y = accelerometer:getAcceleration()
	
	self:movePlayer(x, -y)
end

function Controller:movePlayer(speedX, speedY)
	local curSpeedX, curSpeedY = player:getSpeed()
	
	-- apply IIR filter
	curSpeedX = 50 * (speedX * self.filter + curSpeedX * (1 - self.filter))
	curSpeedY = 100 * (speedY * self.filter + curSpeedY * (1 - self.filter))
	
	player:setSpeed(curSpeedX, curSpeedY)
	player:move()
end