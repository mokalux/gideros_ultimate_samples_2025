Pot = Core.class(Sprite)

function Pot:init(scene,x,y,layer)

	self.scene = scene
	self.x = x
	self.y = y
	self.layer = "layer"

	local pot = Bitmap.new(self.scene.atlas[2]:getTextureRegion("pot 001.png"))
	pot:setAnchorPoint(.5,.5)
	self.pot = pot
	self:addChild(self.pot)
	self.scene.behindRube:addChild(self)

	self.num = 0
	self.canBeStomped = true
	self.alive = true

	table.insert(self.scene.pots, self)
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x,y)
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(20,16,0,0,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 1}
	
	fixture.name = "can hit with butt"
	fixture.parent = self
	self.body = body
	body:setGravityScale(0)

	local filterData = {categoryBits = 2, maskBits = 1}
	fixture:setFilterData(filterData)
	
	--------------------------------------------------------------
	-- Set up particle emmiters
	--------------------------------------------------------------

	if(not(self.scene.potParticles)) then
		local particles = PotSmash.new(self.scene)
		self.scene.frontLayer:addChild(particles)
		self.scene.potParticles = particles
	end
	
	-- set up sounds
	
	if(not(self.scene.smashSound)) then
	
		self.scene.smashSound = Sound.new("Sounds/pot smash small.wav")
		self.scene.smashSound2 = Sound.new("Sounds/pot smash.wav")
		
	end

end



function Pot:stomped()

	self.num = self.num + 1;
	self.canBeStomped = false
	--self:removeChild(self.pot)
			
	if(self.num==1) then
	
		self.channel1 = self.scene.smashSound:play(1)
		self.channel1:setVolume(.7*self.scene.soundVol)	
		self.pot = Bitmap.new(self.scene.atlas[2]:getTextureRegion("pot 002.png"))
		self.pot:setAnchorPoint(.5,.5)
		self:addChild(self.pot)	
		self.scene.hero.body:setLinearVelocity(0, -9)
		
		
	elseif(self.num==2) then
	
		self.channel1 = self.scene.smashSound:play(1)
		self.channel1:setVolume(.7*self.scene.soundVol)	
		self.pot = Bitmap.new(self.scene.atlas[2]:getTextureRegion("pot 003.png"))
		self.pot:setAnchorPoint(.5,.5)
		self:addChild(self.pot)
		self.scene.hero.body:setLinearVelocity(0, -9)
		self.scene.hero.xSpeed = 0
		
	elseif(self.num==3) then
	
		-- pot smashed
		
		self.channel1 = self.scene.smashSound2:play(1)
		self.channel1:setVolume(.7*self.scene.soundVol)	
		self.alive = false
		self:getParent():removeChild(self)
		
		local coin = Coin.new(self.scene,1,1,"yes")
		table.insert(self.scene.coins, coin)
		self.scene.behindRube:addChild(coin)
		coin:setPosition(self:getX(),self:getY()+15)
		
		self.scene.potParticles:setPosition(self:getX(),self:getY()+20)
		self.scene.potParticles.emitter:start()
		
		self.body.destroyed = true
		Timer.delayedCall(10, function()
			self.scene.world:destroyBody(self.body) -- remove physics body
			for i,v in pairs(self.scene.pots) do
				if(v==self) then
					table.remove(self.scene.coins, i)
				end
			end
			--self:getParent():removeChild(self)
		end)
		
		-- coin spawner

		local randNum = math.random(4,8)
		
		local coinTimer = Timer.new(30,randNum)

		coinTimer:addEventListener(Event.TIMER, self.spawnCoin, self)
		coinTimer:addEventListener(Event.TIMER_COMPLETE, function() self.coinTimer:stop()  end)
		self.coinTimer = coinTimer
		self.coinTimer:start()

	end
	
	Timer.delayedCall(500, function() self.canBeStomped = true end)
		
end




function Pot:spawnCoin(event)

	if(not(self.scene.paused)) then
	
		local coin = Coin.new(self.scene,self.x,self.y,"yes",self.layer)
		
		Timer.delayedCall(10, function()
			coin.body:setLinearDamping(0)
		end)
		
		coin.canCollect = false
		table.insert(self.scene.coins, coin)
		
		
		coin:setPosition(self:getX(),self:getY()+15)

		
	end
	
end

