ClawObject = Core.class(Sprite)

function ClawObject:init(scene,startX,startY,type,id)

	self.scene = scene;
	self.startX = startX
	self.startY = startY
	self.type = type
	self.id = id
	self.ignoreCull = true

	local object = Bitmap.new(self.scene.atlas[2]:getTextureRegion(type))

	object:setAnchorPoint(.5,.5)
	self:addChild(object)
	self.scene.rube1:addChild(self)
	self.ignoreCull = true

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}

	body:setAngle(self:getRotation() * math.pi/180);

	if(self.type=="key.png") then

		self.theShape = b2.PolygonShape.new()
		self.theShape:setAsBox(15,15,0,0,0)
		
		-- Add particles for if it is destroyed

		if(not(self.scene.keyParticles)) then
			local particles = KeyParticles.new(self.scene)
			self.scene.frontLayer:addChild(particles)
			self.scene.keyParticles = particles
		end

	else

		self.theShape = b2.CircleShape.new(0,0,15)

	end

	local fixture = body:createFixture{shape = self.theShape, density = .15, friction = .2, restitution = .4}
	local filterData = {categoryBits = 4, maskBits = 2+4+64+128+512+8192}

	fixture:setFilterData(filterData)
	fixture.name = "claw object"
	fixture.parent = self

	self.body = body

	table.insert(self.scene.spritesOnScreen, self)

	self.body:setPosition(self.startX, self.startY);
	table.insert(self.scene.clawObjects, self) -- record to rock table
	
	if(self.type=="key.png") then
		self.scene.keys[id] = self
	end

end



function ClawObject:attachToClaw()

	self.scene.holdingObject = true
	self.scene.theObject = self
	self.scene.claw:stopAndReturnClaw(tonumber(300))
	
end



function ClawObject:destroyKey()

	if(self.scene.hero.direction=="left") then
		self.xOffset = -40
	
	else
		self.xOffset = 40
	end
	
	self.scene.keyParticles:setPosition(self.scene.playerMovement.heroX+self.xOffset, self.scene.playerMovement.heroY+9)
	self.scene.keyParticles.emitter:start()
	self.scene.claw:resetClaw()
	Timer.delayedCall(5, self.removeBody, self)
	Timer.delayedCall(10, self.removeSprite, self)
end



function ClawObject:removeBody()

	if(not(self.body.destroyed)) then
		self.body.destroyed = true
		self.scene.world:destroyBody(self.body) -- remove physics body
	end


end



function ClawObject:removeSprite()

	if(not(self.spriteRemoved)) then
		
		self.spriteRemoved = true
		self:getParent():removeChild(self)
		
	end

end











function ClawObject:makeDangerous()

	self.canHit = true

	Timer.delayedCall(1000, function() self.canHit = false end)

end