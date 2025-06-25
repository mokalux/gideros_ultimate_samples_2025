Loot = Core.class(Sprite)

function Loot:init(scene,image,value,type,x,y,moving,id,startDelay)

	self.startDelay = startDelay
	self.type = type
	self.scene = scene
	self.type = type
	self.value = value
	self.image = image

	if(self.type=="green skull" or self.type=="green spider") then

		local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
		anim:setAnimation(self.image)
		anim:setAnimAnchorPoint(.5,.5)
		anim:addToParent(anim)
		anim:playAnimation()
		self:addChild(anim)
		self.anim = anim

	local timer = Timer.new(3000,math.huge)

	timer:addEventListener(Event.TIMER, self.onTimer, self)
	self.timer = timer
	timer:start()

	elseif(self.type=="trap") then
	
		local loot = Bitmap.new(self.scene.atlas[2]:getTextureRegion(image))
		loot:setAnchorPoint(.5,.5)
		self:addChild(loot)
		
		if(id==1) then
			self.trap = Trap1.new(self.scene,id)
		end
		

	
		self.scene.rube1:addChild(self.trap)
	
	else

		local loot = Bitmap.new(self.scene.atlas[2]:getTextureRegion(image))
		loot:setAnchorPoint(.5,.5)
		self:addChild(loot)
		
	end
	
	-- If this was a pearl, also create the pearl monster
	
	if(self.type=="pearl") then

		local pearlMonster = PearlMonster.new(self.scene,x,y)
		self.myMonster = pearlMonster
	end
	
	self.scene.rube1:addChild(self)
	table.insert(self.scene.clawLoot, self)
	
	-- Add physics

	Timer.delayedCall(1, function()
		local body = self.scene.world:createBody{type = b2.STATIC_BODY, allowSleep = true}
		body:setPosition(x,y)

		local circle = b2.CircleShape.new(0,0,12)
		local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
		
		fixture.name = "loot"
		self.fixture = fixture
		fixture.parent = self
		self.body = body
		body:setGravityScale(0)

		local filterData = {categoryBits = 4096, maskBits = 8912}
		fixture:setFilterData(filterData)

	end)
	
	if(moving) then
		table.insert(self.scene.spritesOnScreen, self)
	end

end





function Loot:onTimer()
	if(not(self.scene.paused)) then
		self.anim:playAnimation()
	end
end



function Loot:collected()


	if(self.myMonster) then
		self.myMonster:close()
	end

	self.body.destroyed = true

	Timer.delayedCall(45, function()

		self.scene.world:destroyBody(self.body) -- remove physics body
		for i,v in pairs(self.scene.clawLoot) do
			if(v==self) then
				table.remove(self.scene.clawLoot, i)
			end
		end
		self:getParent():removeChild(self)
	end)
	
	self.scene.loot = self.scene.loot + self.value
	self.scene.interface:updateLoot()

	
	self.scene.lootValue = self.value
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(400)

	
	if(self.type == "trap") then
		
		Timer.delayedCall(self.startDelay*1000, self.springTrap, self)
	
	end

end



function Loot:springTrap()

	self.trap:doTrap()

end


