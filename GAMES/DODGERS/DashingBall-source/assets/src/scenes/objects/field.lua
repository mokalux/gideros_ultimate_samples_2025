--- Player
cField = Core.class(Sprite)

-- Init
function cField:init(_phy_world)
	self:setAnchorPoint(0.5, 0.5)
	--
	self.angle = 0
	self.isPause = false
	self.phy_world = _phy_world
	self.player = nil
	-- Rotate level
	self.rotate_direction = choose({-1, 1})
	self.rotate_speed = 5
	self.rotate_max_angle = 17
	self.rotate_delay_start = 5000 + math.random(0, 1500)
	self.rotate_timer = nil
	self.rotate_can = false
	-- Global
	GL.GameField = self	
end

-- Start game
function cField:start()
	-- Change state
	self.isPause = true
	GL.GameState = CONST.GAME_STATE.START
	-- Walls
	self.walls = {}
	self.walls.top = cWall.new(0, -CONST.H_CENTER + 112, self.phy_world)
	self:addChild(self.walls.top)
	--
	self.walls.bottom = cWall.new(0, CONST.H_CENTER - 112, self.phy_world)
	self:addChild(self.walls.bottom)
	-- Coin
	self.coin = cCoin.new(self.phy_world)
	self:addChild(self.coin)
	-- Player
	self.player = cPlayer.new(math.floor(math.random(CONST.RANGE_LEFT, CONST.RANGE_RIGHT)), 
	                          CONST.RANGE_BOTTOM, 
							  self.phy_world)
	self:addChild(self.player)
	self.player:setDirection(self.coin:getPosition())
	-- Breaks
	self.break_square = cBreak.new(-CONST.W_CENTER - 32,
									32,
									self.phy_world, CONST.BREAK_TYPE.SQUARE)
	self:addChild(self.break_square)
	
	self.break_circle = cBreak.new(-CONST.W_CENTER - 112,
									-60,
									self.phy_world, CONST.BREAK_TYPE.CIRCLE)
	self:addChild(self.break_circle)
	
	self.break_triangle = cBreak.new(-CONST.W_CENTER - 256,									
									100,
									self.phy_world, CONST.BREAK_TYPE.TRIANGLE)
	self:addChild(self.break_triangle)
	
	self.break_pentago = cBreak.new(-CONST.W_CENTER - 248,
									-90,
									self.phy_world, CONST.BREAK_TYPE.PENTAGON)
	self:addChild(self.break_pentago)
	
	self.break_star = cBreak.new(-CONST.W_CENTER - 320,
									10,
									self.phy_world, CONST.BREAK_TYPE.STAR)
	self:addChild(self.break_star)
	-- Timer rotate
	self.rotate_timer = Timer.new(self.rotate_delay_start, 1)
	self.rotate_timer:addEventListener(Event.TIMER_COMPLETE, self.onRotateTimer, self)
end

-- Callback timer rotate
function cField:onRotateTimer(e)
	self.rotate_can = true
	self.rotate_timer:setDelay(math.random(2500, 5000))
end

-- Play game
function cField:play()
	if (GL.GameState == CONST.GAME_STATE.PAUSE) or (GL.GameState == CONST.GAME_STATE.START) then
		-- Event
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		self.isPause = false
		GL.GameState = CONST.GAME_STATE.GAME
		-- Timer rotate
		self.rotate_timer:start()
		-- Enable control
		self:addEventControlPlayer()
	end
end

-- Pause game
function cField:pause()
	if GL.GameState == CONST.GAME_STATE.GAME then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		self.isPause = true
		GL.GameState = CONST.GAME_STATE.PAUSE
		self.rotate_timer:stop()
		-- Disable control
		self:removeEventControlPlayer()
	end
end

-- Resume game
function cField:resume()
	if GL.GameState == CONST.GAME_STATE.PAUSE then
		self.isPause = false
		GL.GameState = CONST.GAME_STATE.GAME
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		self.rotate_timer:setDelay(math.random(1000, 3000))
		self.rotate_timer:start()
		-- Enable control
		self:addEventControlPlayer()
	end
end

-- Pause game
function cField:gameOver()
	if GL.GameState == CONST.GAME_STATE.GAME then
		self.isPause = true
		GL.GameState = CONST.GAME_STATE.GAMEOVER
		-- Clear evetns
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		self:removeAllListeners()
		-- Clear variable
		self.angle = 0
		self.player:destroy()
		self.player = nil
		-- Timer
		self.rotate_timer:stop()
		self.rotate_can = false
		self.rotate_timer:removeEventListener(Event.TIMER_COMPLETE, self.onRotateTimer, self)
		self.rotate_timer = nil
		-- Disable control
		self:removeEventControlPlayer()
	end
end

-- Callback - enter frame
function cField:onEnterFrame(e)
	if not self.isPause then
		--self:incScore()
		-- Update physics world
		self.phy_world:step(e.deltaTime, 8, 3)
		
		-- Rotate level
		if self.rotate_can then
			self:rotateField(e.deltaTime)
		end
	end
end

-- Rotate level
function cField:rotateField(dt)
	if (self.rotate_direction > 0) then
		if (self:getRotation() > self.rotate_max_angle) then
			self.rotate_direction = -1
			self.rotate_can = false
			self.rotate_timer:start()
		end
	else
		if (self:getRotation() < -self.rotate_max_angle) then
			self.rotate_direction = 1
			self.rotate_can = false
			self.rotate_timer:start()
		end
	end
	self:setRotation(self:getRotation() + self.rotate_direction * self.rotate_speed * dt)
end

-- Add score
function cField:incScore()
	GL.Score = GL.Score + 1
	self:updateScore()
end

-- Update label "Score"
function cField:updateScore()
	-- label
	if GL.GameUI then
		GL.GameUI:updateScore()
	end
end

-- Callback - Control Player - Mouse Handler
function cField:onControlPlayer(e)
	if GL.GameState == CONST.GAME_STATE.GAME then
		self.player:inverseDirection()
	end
end

--
function cField:addEventControlPlayer()
	self:addEventListener(Event.TOUCHES_BEGIN, self.onControlPlayer, self)
end

--
function cField:removeEventControlPlayer()
	self:addEventListener(Event.TOUCHES_BEGIN, self.onControlPlayer, self)
end
