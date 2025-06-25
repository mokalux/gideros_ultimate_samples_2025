CLASS_archer = Core.class(Sprite)

function CLASS_archer:init(world, physics)
	self.pack = TexturePack.new("gfx/frioArcher.txt", "gfx/frioArcher.png")
	
	-- init texture animation loader and read animations... 
	self.archerLoader = CTNTAnimatorLoader.new()

	-- read animation infos from file "frioArcher.tan" use texture pack defined in texturePack and center all sprites...
	self.archerLoader:loadAnimations("gfx/frioArcher.tan", self.pack, true)

	-- box2d
	self.body = world:createBody{type = b2.DYNAMIC_BODY, position = {x = application:getContentWidth()/2, y = 0}}
	item = "FrioArcher"
	self.body.name = item
	physics:addFixture(self.body, item)	
	
	-- allow to callback on collision
	self.body.parent = self
	
	self.anim = CTNTAnimator.new(self.archerLoader)
	self.anim:setAnimation("STAND_RIGHT")
	
	self.anim:setSpeed(180)

    self.anim:addToParent(self)
    self.anim:playAnimation()
	
	self.angle = 0
	
	self.isJumping = false
	self.fly = false
	self.shooting = false
	
	self:setPosition(self.body:getPosition())
	self.nbArrow = 3
end

function CLASS_archer:move(direction, speed)
	if math.cos (direction) < 0 then
		self.angle = 3.14
	else
		self.angle = 0
	end

	if math.deg(direction) < 155 and math.deg(direction) > 105 then
--		print("down")
	end

	local xPos, yPos = self.body:getPosition()
	xPos = xPos + math.cos (direction) * speed 

	if self.angle == 0 then
		self.anim:setAnimation("WALK_RIGHT")
	else
		self.anim:setAnimation("WALK_LEFT")
	end
	self.body:setPosition(xPos, yPos)
end

function CLASS_archer:jump(direction)
	if self.isJumping == false and self.fly == false then
		self.isJumping = true
	end
end

jump = 0
function CLASS_archer:onEnterFrame(Event)
	local xPos, yPos = self.body:getPosition()
	
	if self.isJumping == true then
--		print("jump")
		self.body:setLinearVelocity(0,-12)
		self.isJumping = false
		self.fly = true
		jump = 10
	elseif jump ~= 0 then
		jump = jump - 1
	else
		self.body:setLinearVelocity(0,9)
	end
		
	if xPos > application:getLogicalHeight() then	
		xPos = 0
	elseif xPos < 0 then 
		xPos = application:getLogicalHeight()
	end
	if yPos > application:getLogicalWidth() then
		yPos = 0
		--self.body:setLinearVelocity(0,10)
	elseif yPos < 0 then 
		yPos = application:getLogicalWidth()
	end
	
	
	
	self.body:setPosition(xPos, yPos)
	--self.world:step(1/60, 8, 3)	
	self:setPosition(xPos, yPos)
	--self:setRotation(self.body:getAngle() * 180 / math.pi)
end


function CLASS_archer:stop(direction)
	if math.cos (direction) < 0 then
		self.anim:setAnimation("STAND_LEFT")
	else
		self.anim:setAnimation("STAND_RIGHT")
	end
end

function CLASS_archer:getClassName()
	return "archer"
end

function CLASS_archer:touchFloor()
	self.fly = false
end

function CLASS_archer:toucheByArrow()
	local xPos, yPos = self:getPosition()
--	print(yPos)
	self.anim:setAnimation("DEAD")
end

function CLASS_archer:shoot(orientation)
	self.shooting = true
	if orientation == "left" then
		self.anim:setAnimation("SHOOT_LEFT")
	else
		self.anim:setAnimation("SHOOT_RIGHT")
	end
end

function CLASS_archer:stopShoot(orientation)
	self.shooting = false
	if orientation == "left" then
		self.anim:setAnimation("STAND_LEFT")
	else
		self.anim:setAnimation("STAND_RIGHT")
	end
end