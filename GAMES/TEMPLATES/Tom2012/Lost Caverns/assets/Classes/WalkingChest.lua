WalkingChest = Core.class(Sprite)

function WalkingChest:init(scene,x,y,yDist,startDelay,delayBetween)

	self.scene = scene
	
	if(not(self.scene.walkingChestAnimLoader)) then
	
		local atlas = TexturePack.new("Atlases/Walking Chest.txt", "Atlases/Walking Chest.png", true)
		self.scene.atlas['Walking Chest'] = atlas
	
		local animLoader = CTNTAnimatorLoader.new()
		animLoader:loadAnimations("Animations/Walking Chest.tan", self.scene.atlas['Walking Chest'], true)
		self.scene.walkingChestAnimLoader = animLoader
	
	end
	
	local anim = CTNTAnimator.new(self.scene.walkingChestAnimLoader)
	anim:setAnimation("WALKING_CHEST_SITTING")
--	anim:setAnimAnchorPoint(.2,.5)
	anim:setPosition(5,-3)
	anim:addToParent(anim)
	anim:playAnimation()
	self:addChild(anim)
	self.anim = anim
	self.speed = 2.5
	self.scene.rube2:addChild(self)
	
	self.facing = "left"
	
	-- Add physics
	
	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY}
	self.body = body
	
	-- Main fixture
	
	self.theShape = b2.PolygonShape.new()
	self.theShape:setAsBox(20,20,0,10,0)

	local fixture = body:createFixture{shape = self.theShape, density = 1, friction = .1, restitution = 0,fixedRotation = true}
	local filterData = {categoryBits = 256, maskBits = 2+128}
	fixture:setFilterData(filterData)
	fixture.name = "walking chest"
	fixture.parent = self
	
	-- Near to sensor
	
	self.theShape = b2.PolygonShape.new()
	self.theShape:setAsBox(100,60,0,0,0)

	local fixture = body:createFixture{shape = self.theShape, density = 0, friction = 0, restitution = 0, isSensor=true}
	local filterData = {categoryBits = 2048, maskBits = 8}
	fixture:setFilterData(filterData)
	fixture.name = "follow hero sensor"
	fixture.parent = self

		
	table.insert(self.scene.spritesOnScreen, self)

	self.body:setPosition(x,y)
	table.insert(self.scene.dragBlocks, self) -- so will be included in collisions
	
	-- Set up particles

	local particles = WalkingChestParticles.new(self.scene)
	self.scene.frontLayer:addChild(particles)
	self.particles = particles
	
	table.insert(self.scene.enemies, self)
	
	-- sounds
	
	self.maxVolume = .3
	self.volume = 0
		
	if(not(self.scene.walkingChestSound)) then
	
		self.scene.walkingChestSound = Sound.new("Sounds/walking chest burst.wav")

	end
	
	if(not(self.scene.smashSound)) then
	
		self.scene.smashSound2 = Sound.new("Sounds/pot smash.wav")
		
	end

	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events

end






function WalkingChest:makeFollow()
	
	self:addEventListener(Event.ENTER_FRAME, self.follow, self)
	self:walkAnim()
	self.following = true
	
end




function WalkingChest:stopFollow()

	self:removeEventListener(Event.ENTER_FRAME, self.follow, self)
	self:sitAnim()	
	self.following = false
	
end



function WalkingChest:follow()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		local angle = math.deg(self.body:getAngle())
		
		if(angle < -10) then
			self.body:setAngle(math.rad(-10))
		elseif(angle > 10) then
			self.body:setAngle(math.rad(10))
		end

		local x,y = self.body:getPosition()
		local xVel,yVel = self.body:getLinearVelocity()
		
		-- Go left
		
		if(x > self.scene.playerMovement.heroX) then
			
			local dist = x-self.scene.playerMovement.heroX
			
			-- Not close to hero, walk
			
			if(dist > 45) then
			--	self.body:setPosition(x-1, y)
			

			
			self.body:setLinearVelocity(-self.speed,yVel)
				

				
				-- Update animation
					
				if(self.currentAnim == "sitting") then

					self:walkAnim()

				end
				
				if(self.facing=="right") then
					self.facing = "left"
					self:setScaleX(1)
					
				end
			else
			
				-- Close to hero, sit
				
				if(self.currentAnim == "walking") then
						
					self:sitAnim()
		
				end
			
			end
			
			
			
			
		else
		
			-- Go right
		
			local dist = self.scene.playerMovement.heroX-x
			
			-- Not close to hero, walk
			
			if(dist > 45) then
				--self.body:setPosition(x+1, y)
					self.body:setLinearVelocity(self.speed,yVel)
				
				-- Update animation
					
				if(self.currentAnim == "sitting") then
				
					self:walkAnim()
					
				end
				
				if(self.facing=="left") then
				
					self.facing = "right"
					self:setScaleX(-1)
					
				end
			else
			
				-- Close to hero, sit
				
				if(self.currentAnim == "walking") then

					self:sitAnim()
		
				end
				
			end
		end
	
	end
end




function WalkingChest:crushed()

	if(self.following) then
		self:removeEventListener(Event.ENTER_FRAME, self.follow, self)
	end

	if(not(self.dead)) then

		self.dead = true
		self.body.destroyed = true
		
		self.channel1 = self.scene.smashSound2:play()
		self.channel1:setVolume(1*self.scene.soundVol)	
		

		self.channel2 = self.scene.walkingChestSound:play()
		self.channel2:setVolume(1*self.scene.soundVol)
		self.anim:setVisible(false)


		Timer.delayedCall(10000, function()
			self:getParent():removeChild(self)
			self.scene.world:destroyBody(self.body) -- remove physics body
		end)
		

	
		local x,y = self:getPosition()
		self.particles:setPosition(x,y+12)
		self.particles.emitter:start()
		
		-- Spawn coins
		
		local coin = Coin.new(self.scene,x,y,"yes")
		Timer.delayedCall(10, function()
			coin.body:setLinearDamping(0)
		end)
		table.insert(self.scene.coins, coin)
		self.scene.behindRube:addChild(coin)
		coin:setPosition(x,y)

		local randNum = math.random(4,8)
		
		local coinTimer = Timer.new(30,randNum)
		
		self.spawnX = x
		self.spawnY = y

		coinTimer:addEventListener(Event.TIMER, self.spawnCoin, self)
		coinTimer:addEventListener(Event.TIMER_COMPLETE, function() self.coinTimer:stop()  end)
		self.coinTimer = coinTimer
		self.coinTimer:start()
	
	end
		
end




function WalkingChest:spawnCoin()

	if(not(self.scene.paused)) then

		local coin = Coin.new(self.scene,self.spawnX,self.spawnY,"yes")
		Timer.delayedCall(10, function()
			coin.body:setLinearDamping(0)
		end)
		
		coin.canCollect = false
		table.insert(self.scene.coins, coin)
		self.scene.frontLayer:addChild(coin)
		--coin:setPosition(self:getX(),self:getY()+15)

		
	end
end



function WalkingChest:walkAnim()

	self.currentAnim = "walking"
	self.anim:setAnimation("WALKING_CHEST_BETWEEN")
	
	Timer.delayedCall(100, function()
		self.anim:setAnimation("WALKING_CHEST_WALKING")
		self.anim:playAnimation()
	end)

end




function WalkingChest:sitAnim()

	self.currentAnim = "sitting"
	self.anim:setAnimation("WALKING_CHEST_BETWEEN")
	
	Timer.delayedCall(100, function()
		self.anim:setAnimation("WALKING_CHEST_SITTING")
		self.anim:playAnimation()
	end)

end





function WalkingChest:pause()

	self.anim:pauseAnimation()

end




function WalkingChest:resume()

	self.anim:unPauseAnimation()

end



-- cleanup function

function WalkingChest:exit()

	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end

end

