PlayerMovement = Core.class(Sprite);

function PlayerMovement:init(scene)

	self.scene = scene
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
		
		
	if(not(self.scene.windSpeed)) then
		self.scene.windSpeed = 0
	end
	
	self.xSpeed = 0
	self.ySpeed = 0
	self.yVel = 0
	self.xVel = 0

	-- Variables

	self.speed = 5


	local heroX, heroY = self.scene.hero.body:getPosition()

	-- Create a variable to store number of ground touches

	self.numGroundContacts = 0
	self.numFeetContacts = 0
	self.dampCounter = 0 -- used to decide when to turn on linear damping
	-- self.fallCounter = 0

	-- Work out right edge of loot bar (used in fading it)
	self.lootBarRight = self.scene.worldWidth - 200
	
	
	
	-- set up claw sounds
	
	if(not(self.scene.wingSound)) then
	
		self.scene.wingSound = Sound.new("Sounds/wings.wav")

	end
	
	self.heroX = 0
	self.heroY = 0
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end






function PlayerMovement:moveLeft()

	if(not self.scene.paused and not(self.scene.hero.dead)) then

		self.damped = false
		self.scene.hero.direction = "left"
		self.movingRight = false;
		self.movingLeft = true;
		self.xSpeed = -self.speed
		self.scene.heroAnimation:updateAnimation()
		self.scene.hero.body:setLinearDamping(0)
		self.stopped = false
		
	end

end



function PlayerMovement:moveRight()

	if(not self.scene.paused and not(self.scene.hero.dead)) then

		self.damped = false
		self.scene.hero.direction = "right"
		self.movingLeft = false;
		self.movingRight = true;
		self.xSpeed = self.speed
		self.scene.heroAnimation:updateAnimation()
		self.scene.hero.body:setLinearDamping(0)
		self.stopped = false
		
	end
	
end



function PlayerMovement:moveUp()

	if(not(self.jumpThroughsAreSensors)) then
	
		self.jumpThroughsAreSensors = true

		for i,body in pairs(self.scene.jumpThroughPlatforms) do

			body.fixture:setSensor(true)
		
		end
		
	end

	if(not(self.scene.paused) and not(self.scene.hero.dead)) then
		
		if(not(self.flyingSound)) then
		
			self.flyingSound = true
			self.channel1 = self.scene.wingSound:play(0,true)
			self.channel1:setVolume(.5*self.scene.soundVol)
		
		end
		
		self.movingUp = true
		self.scene.hero.flying = true
		self.scene.hero.falling = false
		self.scene.heroAnimation:updateAnimation()
		self.scene.hero.body:setLinearDamping(0)
		self.damped = false

	end

end


function PlayerMovement:onEnterFrame()

--print(#self.scene.leftButtonTouches,#self.scene.rightButtonTouches)

--print(self.scene.playerMovement.numFeetContacts)

	if(not(self.scene.paused)) then

		-- Get the x and y velocity

		self.xVel, self.yVel = self.scene.hero.body:getLinearVelocity()
		
		-- Get current hero x and y
		
		self.heroX, self.heroY = self.scene.hero.body:getPosition()
		
		-- Set the max (and min) y velocity here
		
		if(self.yVel > 8) then
			self.yVel = 8
		end
		
		if(self.scene.playerMovement.numFeetContacts>0 and self.yVel < -5) then
			self.yVel = -5
		end


		-- when to turn on falling 

		if(not(self.scene.hero.falling) and self.yVel > -1 and self.scene.playerMovement.numFeetContacts == 0 and not(self.scene.playerMovement.movingUp)) then
		
		-- turn on jump throughs
		
			if(self.jumpThroughsAreSensors) then
		
				self.jumpThroughsAreSensors = false

				for i,body in pairs(self.scene.jumpThroughPlatforms) do

					body.fixture:setSensor(false)
				
				end
			
			end
			
			self.scene.hero.flying = false
			self.scene.hero.falling = true
			--self.yVel = 0 -- remove any down force caused by moving against angled ceiling
			self.scene.movingUp = false
			self.scene.heroAnimation:updateAnimation()
		
			
			
			if(self.scene.playerMovement.channel1) then
				self.scene.playerMovement.flyingSound = false
				self.scene.playerMovement.channel1:stop()
			end

		end



		if(self.movingUp and not(self.tired)) then
			self.yVel = -6
		end
		


		-- This bit makes the move

		if(self.heroY < 0) then
			self.scene.hero.body:setPosition(self.heroX+self.xSpeed, 0)
		else
		
		--print("move")
		
		--self.scene.hero.body:setLinearVelocity(self.xSpeed,self.yVel)
		
			if(self.scene.inWindSafeZone) then
				self.scene.hero.body:setLinearVelocity(self.xSpeed,self.yVel)
			else
				self.scene.hero.body:setLinearVelocity(self.xSpeed+self.scene.windSpeed,self.yVel)
				
				--print(self.xSpeed+self.scene.windSpeed)
			end
		end



		-- Do braking
		
		if(#self.scene.leftButtonTouches==0 and #self.scene.rightButtonTouches==0 and not(self.stopped)) then

			-- Decide on braking strength
			
			if(self.numFeetContacts > 0) then
				-- Ground braking
				self.brakeStrength = .4
				


			else
				-- Air braking
				self.brakeStrength = .3
			end
			
			-- Do the braking

				if(self.scene.hero.direction == "left") then

					self.xSpeed = self.xSpeed + self.brakeStrength
						
					-- Finished braking, just stop
					
					self.scene.heroAnimation:updateAnimation()
								
					if(self.xSpeed >= 0 and not (self.stopped)) then
						self.stopped = true
						self.xSpeed = 0
						self.movingLeft = nil
					end
						
				elseif(self.scene.hero.direction == "right") then

					self.xSpeed = self.xSpeed - self.brakeStrength+self.scene.windSpeed
					
					self.scene.heroAnimation:updateAnimation()
						
					-- Finished braking, just stop
								
					if(self.xSpeed <= 0 and not (self.stopped)) then
						self.stopped = true
						self.xSpeed = 0
						self.movingRight = nil

					end

				end
				
				
				if(self.scene.hornsTouching) then
					--self.scene.hero.body:setLinearVelocity(0,0)
					--self.xSpeed = 0
				end

		
		-- End of braking
		end

		-- Completely stop movement for player
		-- Stops sliding down hill

		--print(self.numFeetContacts)

		if(not(self.damped) and self.numFeetContacts > 0 and #self.scene.leftButtonTouches==0 and #self.scene.rightButtonTouches==0) then
			-- increase stop counter
			self.dampCounter = self.dampCounter + 1
			
			-- Note, the number at which damping is applied needs to be different on jump through platforms
			-- Thats because the hero body needs to be given time to 'clear' the jump through platform before it is turned off
		
			if(self.scene.onJumpThrough) then
				self.maxDampCount = 200
			else
				self.maxDampCount = 50
			end
			
			if(self.dampCounter==self.maxDampCount) then
				self.dampCounter = 0
				self.damped = true
				--print("DAMP")
				
				if(self.scene.windSpeed == 0) then
					self.scene.hero.body:setLinearDamping(99999)
				end
				self.scene.heroAnimation:updateAnimation()
			end
			
		end


		if(self.scene.playerMovement.numFeetContacts==0) then
			self.scene.hero.body:setLinearDamping(0)
		end

			-- Update camera
			--self.scene.camera:moveCameraTo(self.heroX,self.heroY)

		
	-- end if not paused
	end

	-- If player moves over loot bar, fade to 50%

	if(self.lootBarDimmed and (self.heroX < 160 or self.heroY > 80 or self.heroX > self.lootBarRight)) then
		self.lootBarDimmed = false
		self.scene.interface.lootBar:setAlpha(1)
	end
	

	if(not(self.lootBarDimmed) and (self.heroX > 160 and self.heroX < self.lootBarRight and self.heroY < 80)) then
		self.lootBarDimmed = true
		self.scene.interface.lootBar:setAlpha(.4)
	end
	
	--print("move")
	--self.scene.windSpeed = -4
	--print(self.xVel)


end







function PlayerMovement:pause()
	
end



function PlayerMovement:resume()

end








-- cleanup function

function PlayerMovement:exit()

	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
  
end