CPlayer = Core.class(Sprite)

function CPlayer:init(animationsLoader)
	self.accel = accelerometer
	self.filter = 0.2  
	self.fx = 0
	self.fy = 0
	self.moveLeft = true
	
	self.anim = CTNTAnimator.new(animationsLoader)
	self.anim:setAnimation("GEORGE_IDLE_LEFT")
    self.anim:addChildAnimation(self)
	self.anim:playAnimation()
	self.w = application:getLogicalWidth() + 32
    
	self.yPos = (application:getLogicalWidth() /2)+60
    self.xPos = application:getLogicalHeight() /2
    self.speed = self.anim:getSpeed() * 800
    self:setPosition(self.xPos, self.yPos)
    self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function CPlayer:onEnterFrame(event)
	local newSpeed = self.speed
	local x, y = self.accel:getAcceleration()
	self.fy = y * self.filter + self.fy * (1 - self.filter)
	if self.fy > 0.20 then 
		newSpeed = self.speed * (self.fy*2)
		self.xPos = self.xPos - (newSpeed * event.deltaTime)
		self.anim:setAnimation("GEORGE_RUN_LEFT")
		self.anim:setSpeed(5000/(newSpeed))
		self.moveLeft = true
	elseif self.fy < -0.20 then
		newSpeed = self.speed * (self.fy * 2)
		self.xPos = self.xPos - (newSpeed * event.deltaTime)
		self.anim:setAnimation("GEORGE_RUN_RIGHT")
		self.anim:setSpeed(5000/(newSpeed*-1))
		self.moveLeft = false
	else
		if self.moveLeft then
			self.anim:setAnimation("GEORGE_IDLE_LEFT")
		else
			self.anim:setAnimation("GEORGE_IDLE_RIGHT")
		end
	end
    self:setPosition(self.xPos, self.yPos)
end
