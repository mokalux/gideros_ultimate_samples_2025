--- Background

BG = Core.class(Sprite)

-- Init
function BG:init()
	-- Color
	self:setFillColor()
	-- Size area
	self.sizeArea = (CONST.W > CONST.H) and CONST.W_CENTER or CONST.H_CENTER
	-- Fps
	self.time_life = 7 * application:getFps()
	-- Rotate
	local _direction = choose({ -1, 1 })
	self.speed = 3 * _direction / application:getFps()
	
	-- Evant application
	self:addEventListener(Event.APPLICATION_SUSPEND, self.onAppSuspend, self)
	self:addEventListener(Event.APPLICATION_RESUME, self.onAppResume, self)
end

-- Callback application resume
function BG:onAppResume(e)
	self.particles:setPaused(false)
	self.timer:start()
end

-- Callback application suspend
function BG:onAppSuspend(e)
	self.particles:setPaused(true)
	self.timer:stop()
end

-- Set color background
function BG:setFillColor(color)
	if (color) then
		application:setBackgroundColor(color)
	else
		application:setBackgroundColor(CONST.BG_COLOR)
	end
end

-- Frame 
function BG:onFrameEnter(e)
	self.obj_rotate:setRotation(self.obj_rotate:getRotation() + self.speed)
end

-- Timer - spawn particles
function BG:onTimer(e)
	for i = 1, 9 do
		self.particles:addParticles({
			{
				x = math.random(-self.sizeArea, self.sizeArea),
				y = math.random(-self.sizeArea, self.sizeArea),
				size = math.random(3, 6.3),
				color = 0xffffff,
				alpha = choose({ 0.1, 0.15, 0.2, 0.25 }),
				ttl = self.time_life,
				speedGrowth = -0.04
			}
		})
	end
end

-- Enable particles
function BG:start()
	-- Particle
	local _p = Particles.new()
	local _parent = Pixel.new(0xff0000, 0, 32, 32)
	_parent:setAnchorPoint(0.5, 0.5)
	_parent:setPosition(CONST.W_CENTER, CONST.H_CENTER)
	_parent:addChild(_p)
	
	self.obj_rotate = _parent
	self.particles = _p	
	self:addChild(self.obj_rotate)
	-- Timer - spawn particel
	self.timer = Timer.new(90, 0)
	self.timer:addEventListener(Event.TIMER, self.onTimer, self)
	self.timer:start()
	-- Add event - rotate
	self:addEventListener(Event.ENTER_FRAME, self.onFrameEnter, self)
end

-- Disable particles
function BG:stop()
	-- Stop spawn
	self.timer:stop()
	self.timer = nil
	-- Remove event
	self:removeEventListener(Event.ENTER_FRAME, self.onFrameEnter, self)
	self:removeEventListener(Event.APPLICATION_SUSPEND, self.onAppSuspend, self)
	self:removeEventListener(Event.APPLICATION_RESUME, self.onAppResume, self)
	-- Clear
	self.particles = nil
end
