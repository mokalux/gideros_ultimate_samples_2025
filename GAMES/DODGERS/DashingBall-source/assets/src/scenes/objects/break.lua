--- Break
cBreak = Core.class(Sprite)

-- Init
function cBreak:init(_x, _y, _phy_world, _type, _scale)
	self.phy_world = _phy_world
	self.shape_type = _type
	self.shape_scale = _scale
	self.speed_move_start = math.floor(math.random(135, 145))
	self.speed_move = self.speed_move_start 
	-- Check parameter scale
	if _scale == nil then
		_scale = 1
	end
	-- Sprite
	self:createSprite(_type, _scale)
	self:setPosition(_x, _y)
	-- Body
	self:createBody("Break", _phy_world, _type, _scale)
	self:updatePositionAndRotate()
	-- Event
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

-- Change size
function cBreak:changeSize(_scale)
	self.shape_scale = _scale
	-- Disable event
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	-- Destory phisycs body
	Timer.delayedCall(1, function()
		self.phy_world:destroyBody(self.body)
		self.body = nil
		-- Scale sprite
		self:setScale(self.shape_scale)
		-- New phisycs bosy
		self:createBody("Break", self.phy_world, self.shape_type, self.shape_scale)
		-- Enable event
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
    end)
end

-- Create sprite
function cBreak:createSprite(_type, _scale)
	-- Type
	if (_type == CONST.BREAK_TYPE.TRIANGLE) then
		self:addChild(GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.BreakTriangle))
	elseif (_type == CONST.BREAK_TYPE.STAR) then
		self:addChild(GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.BreakStar))
	elseif (_type == CONST.BREAK_TYPE.SQUARE) then
		self:addChild(GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.BreakSquare))
	elseif (_type == CONST.BREAK_TYPE.PENTAGON) then
		self:addChild(GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.BreakPentagon))
	elseif (_type == CONST.BREAK_TYPE.CIRCLE) then
		self:addChild(GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.BreakCirle))
	end
	self:setScale(_scale)
	self:setAnchorPoint(0.5, 0.5)
end

-- Create body
function cBreak:createBody(_name, _phy_world, _type, _scale)	
	-- Type Shape
	local _shape = nil
	local _size = self:getHeight() / 2
	-- 
	if (_type == CONST.BREAK_TYPE.STAR) then
		_shape = b2.ChainShape.new()
		_shape:createLoop(    0 * _scale, -_size, 
		                      6 * _scale,     -7 * _scale,
						  _size,              -4 * _scale,
						     10 * _scale,     6 * _scale,	
							 11 * _scale,  _size,
							  0 * _scale,     12 * _scale, 
							-11 * _scale,  _size,
							 -10 * _scale,     6 * _scale,
						 -_size,              -4 * _scale,						    
		                     -6 * _scale,     -7 * _scale)
	--
	elseif (_type == CONST.BREAK_TYPE.TRIANGLE) then
		_shape = b2.PolygonShape.new()
		_shape:set(     0,  -_size, 
		            _size,   _size, 
				   -_size,   _size)
	--
	elseif (_type == CONST.BREAK_TYPE.SQUARE) then
		_shape = b2.PolygonShape.new()
		_shape:setAsBox(_size, _size)
	--
	elseif (_type == CONST.BREAK_TYPE.PENTAGON) then
		_shape = b2.PolygonShape.new()
		_shape:set(     0 * _scale, -_size,	
		            _size,              -4 * _scale, 
				       10 * _scale,  _size,
				      -10 * _scale,  _size,					
				   -_size ,             -4 * _scale)
	--
	elseif (_type == CONST.BREAK_TYPE.CIRCLE) then
		_shape = b2.CircleShape.new(0, 0, _size)
	end
	
	-- Body
	local _body = _phy_world:createBody({ 
		type = b2.DYNAMIC_BODY, 
		isSensor = true
	})
	local _fixture = _body:createFixture({ shape = _shape })
	-- Set filter mask
	_fixture:setFilterData({ 
		categoryBits = CONST.PHYSICS_FILTER.BREAK, 
		maskBits = CONST.PHYSICS_FILTER.BREAK,
		groupIndex = -1
	})
	-- Save player
	_body.name = _name
	self.body = _body
end

-- Updating the position of the sprite relative to the physical object
function cBreak:updatePositionAndRotate()
	local _x, _y = self:getPosition()
	local _angle = self:getRotation()	
	-- Local to Global for physics body
	_x, _y = GL.GameField:localToGlobal(_x, _y)
	local _x_body, _y_body = self.body:getPosition()
	-- Delay 1 milisecond for 1 time
	Timer.delayedCall(1, function()
		-- Change the position of a physical object	
		if self.body then
			self.body:setPosition(_x, _y)
			self.body:setAngle((self:getRotation() + GL.GameField:getRotation()) / 180 * math.pi)
		end
	end)
end

-- Set new position and speed rotate
function cBreak:changePosAngle()
	-- New position
	self:setPosition(
		-CONST.W_CENTER - math.floor(math.random(70, 100)),
		math.floor(math.random(CONST.RANGE_TOP + 115, CONST.RANGE_BOTTOM - 115))
	)
	-- New speed move
	self.speed_move = math.floor(math.random(self.speed_move_start - 20, self.speed_move_start + 50))
end

-- Check position
function cBreak:checkPosition()
	local _x, _y = self:getPosition()
	if (_x > CONST.W_CENTER + 60) then
		-- New size
		self:changeSize(choose({0.75, 0.85, 0.9, 1, 1.15, 1.25, 1.35, 1.5, 1.65, 1.75}))
		-- New position
		self:changePosAngle()
		-- Update position aand angle physics body 
		self:updatePositionAndRotate()
		self:setRotation(choose({0, 90, 180, 270}))
	end
end

-- Event EnterFrame
function cBreak:onEnterFrame(e)
	if (GL.GameState == CONST.GAME_STATE.GAME) then
		-- Move sprite
		local _x, _y = self:getPosition()
		_x = _x + self.speed_move * e.deltaTime
		self:setPosition(_x, _y)
		
		-- Update position physics body
		self:updatePositionAndRotate()
		-- Check
		self:checkPosition()
	end
end
