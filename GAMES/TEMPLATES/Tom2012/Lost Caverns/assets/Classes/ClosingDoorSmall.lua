ClosingDoorSmall = Core.class(Sprite)

function ClosingDoorSmall:init(scene,x,y,atlas,linearVelocity,flip)


	self.scene = scene
	self.linearVelocity = linearVelocity

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("drop door.png"))
	self:addChild(img)
	self.scene.behindRube:addChild(self)
	self.img = img
	img:setAnchorPoint(.5,.5)
	img:setX(-50)
	
	if(not(flip)) then
		img:setScaleX(-1)
	end

	-- add physics
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	body:setGravityScale(0)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(16,60,-50,0,0)
	body:setAngularDamping(math.huge)
	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}

	body.name = "Ground"
	body.name2 = "closingDoor"
	body.parent = self
	self.body = body
	body:setPosition(x,y)

	local filterData = {categoryBits = 256, maskBits = 1}
	fixture:setFilterData(filterData)

	table.insert(self.scene.spritesOnScreen, self)
	
	if(linearVelocity>0) then
		self:setupParticles()
	end

	self.body:setLinearVelocity(0,self.linearVelocity)
	
	self:addEventListener(Event.ENTER_FRAME, self.checkMove, self)
	
	self.startY = y

end
 



function ClosingDoorSmall:checkMove()
	
	local x,y = self.body:getPosition()
	
	--print(y, self.startY+self:getHeight())
	
	

	if(y > self.startY+self:getHeight()+40) then
		self.body:setLinearVelocity(0,0)
		self:removeEventListener(Event.ENTER_FRAME, self.checkMove, self)
	end

end





function ClosingDoorSmall:stop()

	-- particle dust
	
	if(self.linearVelocity>0) then
	
		local bodyX,bodyY = self.body:getPosition()
		self.emitter:setPosition(bodyX,bodyY+155)
		self.emitter:start()
		self.bodyY = bodyY
		Timer.delayedCall(10, self.addSingleBody, self)
		
	end
	
	Timer.delayedCall(1, self.removeBody, self)
	self.body:setLinearVelocity(0,0)
	self.body:setLinearDamping(math.huge)



end



function ClosingDoorSmall:removeBody()

	self.body.destroyed = true
	self.scene.world:destroyBody(self.body) -- remove physics body
	
end





function ClosingDoorSmall:addSingleBody()


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


	local filterData = {categoryBits = 64, maskBits = 1+64}
	fixture:setFilterData(filterData)
--]]


end






function ClosingDoorSmall:setupParticles()

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
