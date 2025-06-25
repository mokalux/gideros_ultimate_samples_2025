--- Player
cPlayer = Core.class(Sprite)

-- Init
function cPlayer:init(_x, _y, _phy_world)
	self.phy_world = _phy_world
	-- Speed
	self.speed = 190
	self.speed_delta = 7
	self.speed_timer = 5
	self.current_time = 0
	--
	self.angle = 0
	self.direction = {
						x = 0,
						y = 0
					}
	-- Sprite
	self:setPosition(_x, _y)
	self:createSprite()
	-- Body
	self:createBody(_x, _y, "Player", self.phy_world)
	-- Events
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	-- Events
	self.phy_world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
end

-- Destroy
function cPlayer:destroy()
	-- Explosion
	self:explosionParticle()
	-- Delay 1 milisecond for 1 time
	Timer.delayedCall(1, function()
        -- Destroy physics body
		self.phy_world:destroyBody(self.body)
		self.body = nil
    end)
	-- Clear sprite
	self:removeChild(self.sprite)
	self:removeAllListeners()
end

-- Explosion particle
function cPlayer:explosionParticle()
	EffectExplodeEx(self, 0.5, 14, 14, 100, 2, 70, CONST.PARTICLE_PLAYER_COLOR)
	--Core.asyncCall(EffectExplode, self, 0.5, 14, 14, 100, 2, 70, CONST.PARTICLE_PLAYER_COLOR)
end

-- Set direction
function cPlayer:setDirection(_x, _y)
	if _x and _y then
		self.direction = {
							x = _x,
							y = _y
						}
	end
	-- Update velocity body
	local _ax, _ay = self:getPosition()
	self.angle = getAngelTwoPoints(_ax, _ay, self.direction.x, self.direction.y)
	
	local _vx, _vy = getVelocityFromAngle(self.angle)
	self.direction = { x = _vx, y = _vy }
end

-- Inverse direction
function cPlayer:inverseDirection()
	self.angle = self.angle + 180
	local _vx, _vy = getVelocityFromAngle(self.angle)
	self.direction = { x = _vx, y = _vy }
end

-- Update position
function cPlayer:updatePosition(dt)
	-- Updating the position of the sprite relative to the physical object
	local _x, _y = self:getPosition()
	_x = _x + self.speed * self.direction.x * dt
	_y = _y + self.speed * self.direction.y * dt
	self:setPosition(_x, _y)
	-- Local to Global for physics body
	_x, _y = GL.GameField:localToGlobal(_x, _y)
	-- Delay 1 milisecond for 1 time
	Timer.delayedCall(1, function()
        -- Change the position of a physical object	
		self.body:setPosition(_x, _y)
    end)
end

-- Callback EnterFrame
function cPlayer:onEnterFrame(e)
	-- Update position
	if GL.GameState == CONST.GAME_STATE.GAME then
		self:updatePosition(e.deltaTime)
		self.current_time = self.current_time + e.deltaTime
		if self.current_time > self.speed_timer then
			self.speed = self.speed + self.speed_delta
			self.current_time = 0
		end
	end
end

-- Create sprite
function cPlayer:createSprite()
	-- Sprite
	self.sprite = GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.Player)
	self:addChild(self.sprite)
	self:setAnchorPoint(0.5, 0.5)
end

-- Create body
function cPlayer:createBody(_x, _y, _name, _phy_world)	
	-- Body
	local _body = _phy_world:createBody({ type = b2.DYNAMIC_BODY })

	-- Shape
	local _circle = b2.CircleShape.new(0, 0, self:getHeight() / 2)
	local _fixture = _body:createFixture({
											shape = _circle, 
											density = 1.0, 
											friction = 0, 
											restitution = 0,
										})
	-- Set filter mask
	_fixture:setFilterData({ 
								categoryBits = CONST.PHYSICS_FILTER.PLAYER, 
								maskBits = CONST.PHYSICS_FILTER.WALL + 
								           CONST.PHYSICS_FILTER.BREAK +
										   CONST.PHYSICS_FILTER.COIN
							})
	-- Save player
	_body.name = _name
	self.body = _body
	
	-- Set direction move
	self:setDirection()
	self:updatePosition(0)
end

-- Callback begin contact
function cPlayer:onBeginContact(e)
	local bodyA = e.fixtureA:getBody()
	local bodyB = e.fixtureB:getBody()
	
	if ((bodyA.name == "Player") and (bodyB.name == "Coin")) or
	   ((bodyB.name == "Player") and (bodyA.name == "Coin")) then
		GL.GameField.coin:changePosition()
		GL.GameField:incScore()
		self:setDirection(GL.GameField.coin:getPosition())
	elseif ((bodyA.name == "Player") and ((bodyB.name == "Wall") or (bodyB.name == "Break"))) or
           ((bodyB.name == "Player") and ((bodyA.name == "Wall") or (bodyA.name == "Break"))) then
		GL.Game:gameOver()
	end
end
