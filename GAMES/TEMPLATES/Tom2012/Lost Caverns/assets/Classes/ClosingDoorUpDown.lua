ClosingDoorUpDown = Core.class(Sprite)

function ClosingDoorUpDown:init(scene,x,y,atlas,linearVelocity)

	self.scene = scene
	self.linearVelocity = linearVelocity
	self.x = x
	self.y = y
	
	-- Decide on image
	
	if(linearVelocity>0) then
		self.doorImage = "big door 01.png"
		self.xNudge = 0
		self.downDoor = true
	else
		self.doorImage = "big door 02.png"
		self.xNudge = 4
	end
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion(self.doorImage))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.behindRube:addChild(self)
	img:setX(self.xNudge)
	self.img = img

	-- add physics
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	body:setGravityScale(0)
	
	local poly = b2.PolygonShape.new()
	
	self.bodyW = img:getWidth()
	self.bodyH = img:getHeight()
	
	poly:setAsBox((self.bodyW/2)-10,(img:getHeight()/2)-3,0,0,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}

	body.name = "Ground"
	body.name2 = "closingDoor"
	body.parent = self
	self.body = body

	local filterData = {categoryBits = 64, maskBits = 1+4+64}
	fixture:setFilterData(filterData)

	table.insert(self.scene.spritesOnScreen, self)
	
	if(linearVelocity>0) then
		self:setupParticles()
	end
	
	
	
	-- sounds
	
	self.maxVolume = 1
	self.volume = 0
		
	if(not(self.scene.stoneSlamSound)) then
	
		self.scene.stoneSlamSound = Sound.new("Sounds/long door slam.wav")
		
	end
	
	
	if(not(self.scene.openSound)) then
	
		self.scene.openSound = Sound.new("Sounds/spike open.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.openSound:play(0,math.huge,true)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)


end



function ClosingDoorUpDown:close()

	self.body:setLinearVelocity(0,self.linearVelocity)
	
	if(self.downDoor) then
		self.channel1:setPaused(false)
		self.channel1:setVolume(self.volume*self.scene.soundVol)
	end

end






function ClosingDoorUpDown:stop()

	-- particle dust
	
	if(self.linearVelocity>0) then
	
		local bodyX,bodyY = self.body:getPosition()
		self.emitter:setPosition(bodyX,bodyY+155)
		self.emitter:start()
		self.bodyY = bodyY
		Timer.delayedCall(10, self.addSingleBody, self)
		
	end
	
	if(self.channel1) then
		self.channel1:setPaused(true)
		self.channel1:setVolume(self.volume*self.scene.soundVol)
	end
	
	if(self.downDoor) then
		self.channel2 = self.scene.stoneSlamSound:play()
		self.channel2:setVolume(self.volume*self.scene.soundVol)
	end
	
	Timer.delayedCall(1, self.removeBody, self)
	self.body:setLinearVelocity(0,0)
	self.body:setLinearDamping(math.huge)
		
end






function ClosingDoorUpDown:removeBody()

	self.body.destroyed = true
	self.scene.world:destroyBody(self.body) -- remove physics body
	
end





function ClosingDoorUpDown:addSingleBody()


	-- add physics
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	body:setPosition(self.x, self.y+self.bodyH/2)
	body:setGravityScale(0)
	
	local poly = b2.PolygonShape.new()
	

	
	poly:setAsBox((self.bodyW/2)-10,self.bodyH,0,self.bodyH/2,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}

	body.name = "Ground"
	--body.name2 = "closingDoor"
	body.parent = self


	local filterData = {categoryBits = 64, maskBits = 1+4+64}
	fixture:setFilterData(filterData)
--]]


end






function ClosingDoorUpDown:setupParticles()

	-- Set up particles

	local particles1 = self.scene.atlas[2]:getTextureRegion("dust.png")
	local particles2 = self.scene.atlas[2]:getTextureRegion("spark.png")

	-- clouds right

	local parts1 = CParticles.new(particles1, 10, 2, .5, "alpha")
	parts1:setSpeed(30, 40)
	parts1:setSize(.1)
	parts1:setColor(255,255,255)
	parts1:setLoopMode(1)
	parts1:setAlphaMorphOut(0, 3)
	parts1:setDirection(-10, 4)
	parts1:setSizeMorphOut(2, 5)
	
	-- clouds left

	local parts2 = CParticles.new(particles1, 10, 2, .5, "alpha")
	parts2:setSpeed(30, 40)
	parts2:setSize(.1)
	parts2:setColor(255,255,255)
	parts2:setLoopMode(1)
	parts2:setAlphaMorphOut(0, 3)
	parts2:setDirection(180, 190)
	parts2:setSizeMorphOut(2, 5)

	-- sparks left

	local parts3 = CParticles.new(particles2, 15, 1.5, 0, "alpha")
	parts3:setSpeed(50, 80)
	parts3:setSize(0.1, .4)
	parts3:setLoopMode(1)
	parts3:setColor(255,255,255)
	parts3:setRotation(0, -160, 360, 160)
	parts3:setAlphaMorphOut(50, .5)
	parts3:setDirection(180,190)
	
	-- sparks right

	local parts4 = CParticles.new(particles2, 16, 1.5, 0, "alpha")
	parts4:setSpeed(50, 80)
	parts4:setSize(0.1, .4)
	parts4:setLoopMode(1)
	parts4:setColor(255,255,255)
	parts4:setRotation(0, -160, 360, 160)
	parts4:setAlphaMorphOut(50, .5)
	parts4:setDirection(-10, 4)

	---------------------------------------------------------------------
	-- assign particles to emitters

	local emitter = CEmitter.new(0,0,0, self.scene.rube2)
	self.emitter = emitter
	table.insert(self.scene.particleEmitters, self.emitter)

	emitter:assignParticles(parts1)
	emitter:assignParticles(parts2)
	emitter:assignParticles(parts3)
	emitter:assignParticles(parts4)
	
end
