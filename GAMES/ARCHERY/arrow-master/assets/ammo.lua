CLASS_ammo = Core.class(Sprite)

function CLASS_ammo:init(world, physics)
	self.pack = TexturePack.new("gfx/frioArcher.txt", "gfx/frioArcher.png")
	
	-- init texture animation loader and read animations... 
	self.ammoLoader = CTNTAnimatorLoader.new()

	-- read animation infos from file "frioArcher.tan" use texture pack defined in texturePack and center all sprites...
	self.ammoLoader:loadAnimations("gfx/frioArcher.tan", self.pack, true)

	-- box2d
	self.body = world:createBody{type = b2.DYNAMIC_BODY, position = {x = (math.random(0, 100) * application:getContentWidth() / 100), y = 10}}
	item = "item"
	self.body.name = item
	physics:addFixture(self.body, item)	
	
	-- allow to callback on collision
	self.body.parent = self
	
	self.anim = CTNTAnimator.new(self.ammoLoader)
	self.anim:setAnimation("AMMO")
	
	self.anim:setSpeed(100)

    self.anim:addToParent(self)
    self.anim:playAnimation()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self:setPosition(self.body:getPosition())
	self.destroy = false
end

function CLASS_ammo:onEnterFrame(Event)
	if self.destroy == false then
		local xPos, yPos = self.body:getPosition()
			
		if xPos > application:getLogicalHeight() then	
			xPos = 0
		elseif xPos < 0 then 
			xPos = application:getLogicalHeight()
		end
		if yPos > application:getLogicalWidth() then
			yPos = 0
		elseif yPos < 0 then 
			yPos = application:getLogicalWidth()
		end

		self.body:setPosition(xPos, yPos)
		self:setPosition(xPos, yPos)
	end
end

function CLASS_ammo:collision(with)
	if with == "FrioArcher" then

	end
end
