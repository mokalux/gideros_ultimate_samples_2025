--- Coin
cCoin = Core.class(Sprite)

-- Init
function cCoin:init(_phy_world)
	self.phy_world = _phy_world
	
	-- Sprite
	self:createSprite()
	
	-- Body
	self:createBody("Coin", _phy_world)
	
	-- First position
	self:setPosition(math.floor(math.random(CONST.RANGE_LEFT, CONST.RANGE_RIGHT)), CONST.RANGE_TOP)
	self:updatePosition()
	-- Events
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

-- Create sprite
function cCoin:createSprite()
	-- Sprite
	self:addChild(GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.Coin))
	self:setAnchorPoint(0.5, 0.5)
end

-- Create body
function cCoin:createBody(_name, _phy_world)		
	-- Body
	local _body = _phy_world:createBody({ 
											type = b2.DYNAMIC_BODY, 
											isSensor = true
										})

	-- Shape
	local _circle = b2.CircleShape.new(0, 0, self:getHeight() / 2 + 1)
	local _fixture = _body:createFixture({ shape = _circle })
	-- Set filter mask
	_fixture:setFilterData({ 
								categoryBits = CONST.PHYSICS_FILTER.COIN, 
								maskBits = CONST.PHYSICS_FILTER.PLAYER
							})
	-- Save player
	_body.name = _name
	self.body = _body
end

-- Change position
function cCoin:changePosition()
	local _x, _y = self:getPosition()
	-- New position
	_x = math.random(CONST.RANGE_LEFT, CONST.RANGE_RIGHT)
	_y = -_y
	-- Set
	self:setPosition(_x, _y)
	self:updatePosition()
end

-- Updating the position of the sprite relative to the physical object
function cCoin:updatePosition()
	local _x, _y = self:getPosition()
	local _angle = self:getRotation()
	-- Local to Global for physics body
	_x, _y = GL.GameField:localToGlobal(_x, _y)
	-- Delay 1 milisecond for 1 time
	Timer.delayedCall(1, function()
        -- Change the position of a physical object	
		self.body:setPosition(_x, _y)
    end)
end

-- Event EnterFrame
function cCoin:onEnterFrame(e)
	-- Update position
	if GL.GameState == CONST.GAME_STATE.GAME then
		self:updatePosition()
	end
	-- Particle
	EffectExplodeEx(self, 0.22, 12, 12, 5, 1, 1, CONST.PARTICLE_COIN_COLOR)
	--Core.asyncCall(EffectExplode, self, 0.22, 12, 12, 5, 1, 1, CONST.PARTICLE_COIN_COLOR)
end
