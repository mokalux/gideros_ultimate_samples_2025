PearlMonster = Core.class(Sprite)

function PearlMonster:init(scene,x,y)

	self.scene = scene
	
	-- Neck
	
	self.neckNum = 0
	
	for i=1,5 do
	
		local img = Bitmap.new(self.scene.atlas[12]:getTextureRegion("pearl monster neck.png"))
		img:setAnchorPoint(.5,0)
		self:addChild(img)
		img:setY(-30+self.neckNum)
		self.neckNum = self.neckNum+70
		img:setRotation(math.random(-10,10))
		
	end
	
	local img = Bitmap.new(self.scene.atlas[12]:getTextureRegion("pearl monster jaw left.png"))
	img:setAnchorPoint(0,.5)
	img:setScaleX(-1)
	self:addChild(img)
	img:setX(-20)
	self.jawL = img
	
	local img = Bitmap.new(self.scene.atlas[12]:getTextureRegion("pearl monster jaw right.png"))
	img:setAnchorPoint(0,.5)
	self:addChild(img)
	img:setX(20)
	self.jawR = img
	
	self.velocity = 3.8
	self.gravity = 2.3

	self.scene.behindRube:addChild(self)
	
	self:setPosition(x,y+100)
	
--	Timer.delayedCall(500, self.close, self)
	
	self.startY = self:getY()
	
	
	-- Add physics
	
	-- Left jaw

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false,fixedRotation =true}
	body.name = "Ground"
	self.leftBody = body
	self.leftBody:setLinearDamping(math.huge)
	self.leftBody:setPosition(self:getPosition())
	
	-- Physical fixture
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(80,10,-90,-10,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0}
	local filterData = {categoryBits = 64, maskBits = 1+4+8}
	fixture:setFilterData(filterData)
	self.fixture1 = fixture
	
	-- Stinger
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(80,10,-90,-20,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor = true}
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	fixture.name = "enemy"

	
	--Right Jaw
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false,fixedRotation =true}
	body.name = "Ground"
	body:setLinearDamping(math.huge)
	self.rightBody = body
	self.rightBody:setPosition(self:getPosition())
	
	-- Physical fixture
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(80,10,90,-10,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0}
	local filterData = {categoryBits = 64, maskBits = 1+4+8}
	fixture:setFilterData(filterData)
	self.fixture2 = fixture
	
	-- Stinger
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(80,10,90,-20,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor = true}
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	fixture.name = "enemy"

	
	
	
	-- Set up particles

	local particles1 = self.scene.atlas[2]:getTextureRegion("dust.png")
	local particles2 = self.scene.atlas[2]:getTextureRegion("spark.png")

	-- particles 1

	local parts1 = CParticles.new(particles1, 10, 2, 0, "alpha")
	parts1:setSpeed(20, 40)
	parts1:setSize(.5, 2)
	parts1:setColor(255,255,255)
	parts1:setLoopMode(1)
	parts1:setRotation(0, -160, 360, 160)
	--parts1:setAlphaMorphIn(100, .6)
	parts1:setAlphaMorphOut(50, .5)
	--parts1:setDirection(-60, 60)
	--parts1:setSizeMorphOut(0.2, 0.9)
	--parts1:setGravity(0, 250)
	--parts1:setSpeedMorphOut(450, 1, 450, 0.5)

	-- particles 2

	local parts2 = CParticles.new(particles2, 15, 1.8, 0, "alpha")
	parts2:setSpeed(15, 40)
	parts2:setSize(0.1, .4)
	parts2:setLoopMode(1)
	parts2:setColor(255,255,255)
	parts2:setRotation(0, -160, 360, 160)
	parts2:setAlphaMorphOut(50, .5)
	parts2:setDirection(-40, 40)
	parts2:setGravity(0, -60)

	---------------------------------------------------------------------
	-- assign particles to emitters

	local emitter = CEmitter.new(0,0,-90, self.scene.layer0)
	self.emitter = emitter
	table.insert(self.scene.particleEmitters, self.emitter)

	emitter:assignParticles(parts1)
	emitter:assignParticles(parts2)
	
	--emitter:setPosition(self:getPosition())

	---------------------------------------------------------------------
	-- start emitters
	
	--emitter:start()
	

	
	-- sounds
	
	self.maxVolume = .7
	self.volume = 0
		
	if(not(self.scene.wormRumbleSound)) then
	
		self.scene.wormRumbleSound = Sound.new("Sounds/worm rumble.wav")
		self.scene.wormBiteSound = Sound.new("Sounds/worm bite.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.wormRumbleSound:play(0,math.huge,true)
	self.channel1:setVolume(0)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	--self:close()
	
	self.scene:addEventListener("onExit", self.onExit, self)
	
end


function PearlMonster:close()

	self.channel1:setPaused(false)
	self:addEventListener(Event.ENTER_FRAME, self.moveMe, self)
	

end



function PearlMonster:moveMe()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		self:setY(self:getY()-self.velocity)
		self.velocity = self.velocity - .02
		
		if(self.velocity <= .1) then
			self.leftBody:setActive(true)
			self.rightBody:setActive(true)
			self.canKill = true
			
			
			if(self.jawL:getRotation() > 60) then
				local filterData = {categoryBits = 0, maskBits = 0}
				self.fixture1:setFilterData(filterData)
				self.fixture2:setFilterData(filterData)
			end
			
			
			if(self.jawL:getRotation() < 90) then
				self.jawL:setRotation(self.jawL:getRotation() + self.gravity)
				self.jawR:setRotation(self.jawR:getRotation() - self.gravity)
			else
				
				if(not(self.shut)) then
				
					self.channel2 = self.scene.wormBiteSound:play()
					self.channel2:setVolume(self.volume*self.scene.soundVol)
				
					self.shut = true
					self.emitter:setPosition(self:getX()-15,self:getY()-200)
					self.emitter:start()
				end
			
			
			end
		end
		
		self.leftBody:setPosition(self:getPosition())
		self.leftBody:setAngle(math.rad(self.jawL:getRotation()))
		self.rightBody:setPosition(self:getPosition())
		self.rightBody:setAngle(math.rad(self.jawR:getRotation()))
		
		if(self:getY()>self.startY+300) then
				if(self.channel1) then
					self.channel1:setPaused(true)
				end
				self.leftBody.destroyed = true
				self.rightBody.destroyed = true
				self.scene.world:destroyBody(self.leftBody)
				self.scene.world:destroyBody(self.rightBody)
				self:removeFromVolume()
				self:removeEventListener(Event.ENTER_FRAME, self.moveMe, self)
				self.scene.behindRube:removeChild(self)

				
			
		end

	end

end





function PearlMonster:removeFromVolume()

	for i,v in pairs(self.scene.spritesWithVolume) do
		if(v==self) then
			table.remove(self.scene.spritesWithVolume, i)
		end
	end

end




-- cleanup function

function PearlMonster:onExit()
	
	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.moveMe, self)
	end
	
	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self.scene:removeEventListener("onExit", self.onExit, self)

end
