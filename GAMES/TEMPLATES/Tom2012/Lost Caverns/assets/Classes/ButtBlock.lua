ButtBlock = Core.class(Sprite)

function ButtBlock:init(scene,x,y)

	self.scene = scene
	self.x = x
	self.y = y

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("butt block.png"))
	img:setAnchorPoint(.5,.5)
	self.img = img
	self:addChild(img)
	self.scene.behindRube:addChild(self)

	self.num = 0
	self.canBeStomped = true
	self.alive = true
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x,y)
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(20,16,0,0,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0}
	
	fixture.name = "can hit with butt"
	fixture.parent = self
	self.body = body
	self.body:setLinearDamping(math.huge)
	body.name = "Ground"

	local filterData = {categoryBits = 2, maskBits = 1}
	fixture:setFilterData(filterData)
	
	--------------------------------------------------------------
	-- Set up particle emmiters
	--------------------------------------------------------------

	local particles1 = self.scene.atlas[2]:getTextureRegion("butt block particle.png");

	---------------------------------------------------------------------
	-- particles 1
	---------------------------------------------------------------------

	local parts1 = CParticles.new(particles1, 15, .8, 0,"alpha")
	parts1:setSpeed(20, 70)
	parts1:setSize(0.5, .8)
	parts1:setColor(255,255,255)
	parts1:setLoopMode(1)
	parts1:setRotation(0, -160, 360, 160)

	parts1:setAlphaMorphOut(50, .3)
	parts1:setDirection(0, 360)

	-- assign particles to emitters

	local emitter = CEmitter.new(0,0,-90, self)
	self.emitter = emitter
	table.insert(self.scene.particleEmitters, emitter)

	emitter:assignParticles(parts1)
	self:addChild(emitter)
	
	-- sounds
	
		if(not(self.scene.rustleSound)) then
	
		self.scene.rustleSound = Sound.new("Sounds/leaves rustle.wav")
		
	end

end



function ButtBlock:stomped()
	

	self.scene.hero.body:setLinearVelocity(self.scene.playerMovement.xVel, -5)
	
	self.canBeStomped = false
	self.emitter:start()

	if(self.alive) then
	
		local channel1 = self.scene.rustleSound:play()
		channel1:setVolume(.2*self.scene.soundVol)
		
		self.alive = false
		self.img:setVisible(false)
		Timer.delayedCall(10, self.removeBody, self)
		Timer.delayedCall(1000, self.killSelf, self)

	end

end



function ButtBlock:removeBody()

	self.body.destroyed = true
	self.scene.world:destroyBody(self.body)

end




function ButtBlock:killSelf()

	self.scene.behindRube:removeChild(self)

end