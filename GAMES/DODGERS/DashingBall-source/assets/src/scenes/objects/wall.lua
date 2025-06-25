--- Wall
cWall = Core.class(Sprite)

-- Init
function cWall:init(_x, _y, _phy_world)
	self.phy_world = _phy_world
	-- Sprite
	self:createSprite()
	self:setPosition(_x, _y)
	self:setRotation(90)
	-- Body
	self:createBody("Wall", _phy_world)
	self:updatePositionAndRotate()
	-- Events
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

-- Create sprite
function cWall:createSprite()
	-- Sprite
	self:addChild(GL.getBmpFromPack(CONST.RESOURCE_NAME.Game.Wall))
	self:setAnchorPoint(0.5, 0.5)
end

-- Create body
function cWall:createBody(_name, _phy_world)	
	-- Body
	local _body = _phy_world:createBody({ 
											type = b2.DYNAMIC_BODY, 
											isSensor = true
										})
	-- Shape
	local _box = b2.PolygonShape.new()
	_box:setAsBox(self:getWidth() / 2, self:getHeight() / 2)
	local _fixture = _body:createFixture({ shape = _box })
	-- Set filter mask
	_fixture:setFilterData({ 
								categoryBits = CONST.PHYSICS_FILTER.WALL, 
								maskBits = CONST.PHYSICS_FILTER.PLAYER
							})
	-- Save player
	_body.name = _name
	self.body = _body
end

-- Updating the position of the sprite relative to the physical object
function cWall:updatePositionAndRotate()
	local _x, _y = self:getPosition()
	local _angle = self:getRotation()
	-- Local to Global for physics body
	_x, _y = GL.GameField:localToGlobal(_x, _y)
	local _x_body, _y_body = self.body:getPosition()
	if (_x ~= _x_body) or (_y ~= _y_body) then
		-- Delay 1 milisecond for 1 time
		Timer.delayedCall(1, function()
			-- Change the position of a physical object	
			self.body:setPosition(_x, _y)
			self.body:setAngle(GL.GameField:getRotation() / 180 * math.pi)
		end)
	end
end

-- Event EnterFrame
function cWall:onEnterFrame(e)
	-- Update position
	if GL.GameState == CONST.GAME_STATE.GAME then
		self:updatePositionAndRotate()
	end
end
