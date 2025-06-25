Claw = Core.class(Sprite)

function Claw:init(x, y, angle,scene)

	self.scene = scene
	self.x = x
	self.y = y
	self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw open.png"));
	self.claw:setAnchorPoint(.5, .5)

	self.scene.claw = self
	self.angle = angle
	self.initialAngle = angle
	self.claw:setRotation(math.deg(self.angle))
	self.xPos = x
	self.yPos = y
	self:setPosition(self.xPos, self.yPos)
	self:addChild(self.claw)
	self.outSpeed = 4
	self.backSpeed = 4
	self.stoppingDistance = 25
	self.maxLength = 200
	self.scene.firingClaw = true


	-- Create the claw line
	
	local clawLine = Bitmap.new(Texture.new("gfx/line.png", true));
	self.scene.hero:addChild(clawLine)
	clawLine:setAnchorPoint(.5,0)
	clawLine:setScaleY(10)
	self.clawLine = clawLine
	
	-- Add physics

	Timer.delayedCall(1, self.addPhysics, self)
	
	-- set up claw sounds
	
	if(not(self.scene.clawSound)) then
	
		self.scene.clawSound = Sound.new("Sounds/fire claw.wav")
		self.scene.collectGoldSound = Sound.new("Sounds/collect gold.wav")
		self.scene.clawCloseSound = Sound.new("Sounds/claw close.wav")
		self.scene.clawCloseOnTreasureSound = Sound.new("Sounds/close on treasure.wav")
		self.scene.harvestCrystalSound = Sound.new("Sounds/harvest crystal.wav")
		self.scene.collectGlassSound = Sound.new("Sounds/collect glass.wav")
		self.scene.blockerSound = Sound.new("Sounds/hit blocker.wav")
		
	end
	
		-- set up sounds
	
	if(not(self.scene.popSound)) then
	
		self.scene.popSound = Sound.new("Sounds/pop.wav")

	end
	
	if(not(self.scene.splatSound2)) then
	
		self.scene.splatSound2 = Sound.new("Sounds/splat 2.wav")

	end
	
	local channel1 = self.scene.clawSound:play()
	channel1:setVolume(.3*self.scene.soundVol)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.scene:addEventListener("onExit", self.onExit, self)

end




function Claw:addPhysics()

		local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
		body:setPosition(self.x,self.y)
		
		local circle = b2.CircleShape.new(0,0,19)
		local fixture = body:createFixture{shape = circle, density = .1, friction = 0, restitution = 0,isSensor= true}
		

		
		fixture.name = "claw"
		body.name = "claw"
		fixture.parent = self
		self.body = body

		local filterData = {categoryBits = 8192, maskBits = 2+4+128+256+4096}

		fixture:setFilterData(filterData)
		table.insert(self.scene.spritesOnScreen, self)
		
		-- add velocity

		body:setGravityScale(0)
		
		local x,y = self.body:getPosition()
		
		local vectorX = math.cos(self.angle) * 1.2
		local vectorY = math.sin(self.angle) * 1.2
		
		body:applyLinearImpulse(vectorX,vectorY, x,y)

end




function Claw:stopAndReturnClaw(delay,particles,hitBlocker)

	if(not(self.returning)) then
		
		self.returning = true

		Timer.delayedCall(45, function()
			self.claw:setVisible(false)
			self.body:setLinearVelocity(0,0)
			self.body:setAngularVelocity(0)
			self.scene.firingClaw = false
			self.scene.pauseClaw = true
			self:removeChild(self.claw)
		
		--print("stopAndReturn")
		

		-- decide what graphics to show

		if(self.scene.clawCollected) then

			if(self.scene.clawCollected.type == "gold") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed gold.png"))
				local channel1 = self.scene.clawCloseOnTreasureSound:play()
				channel1:setVolume(.3*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "fly gold") then
			
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed gold.png"))
				local channel1 = self.scene.collectGoldSound:play()
				channel1:setVolume(.1*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.image == "gold owl.png") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw with owl.png"))
				local channel1 = self.scene.collectGoldSound:play()
				channel1:setVolume(.1*self.scene.soundVol)
				if(self.scene.hero:getX() < self.scene.clawCollected:getX()) then
				
					self.claw:setScaleY(-1)
				end
				
			elseif(self.type == "shy eye") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw with shy eye.png"))
				if(self.scene.hero:getX() < self.scene.clawCollected:getX()) then
					self.claw:setScaleY(-1)
				end
				
			elseif(self.scene.clawCollected.type == "turret gold") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed turret gold.png"))
				--clawCloseOnTreasureSound
				local channel1 = self.scene.clawCloseOnTreasureSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "green skull") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed green skull.png"))
				local channel1 = self.scene.collectGlassSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "pearl") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed pearl.png"))
				local channel1 = self.scene.clawCloseOnTreasureSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "plain fruit") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed fruit.png"))
				local channel1 = self.scene.popSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "exploding fruit") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed exploding fruit.png"))
				local channel1 = self.scene.popSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "sad fruit") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed sad fruit.png"))
				local channel1 = self.scene.popSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "happy fruit") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed happy fruit.png"))
				local channel1 = self.scene.popSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "green spider") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed green spider.png"))
				local channel1 = self.scene.collectGlassSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "red crystal") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed red crystal.png"))
				local channel1 = self.scene.harvestCrystalSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "purple crystal") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed purple crystal.png"))
				local channel1 = self.scene.harvestCrystalSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
				
			elseif(self.scene.clawCollected.type == "creeper bug") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed creeper bug.png"))
				
			elseif(self.scene.clawCollected.type == "claw closed mite") then
				self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed mite.png"))
			end
			
		else 
			self.claw = Bitmap.new(self.scene.atlas[2]:getTextureRegion("claw closed.png"))

			-- if hit blocker
			
			if(hitBlocker) then
			
				local channel1 = self.scene.blockerSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
			
			else

				local channel1 = self.scene.clawCloseSound:play()
				channel1:setVolume(.4*self.scene.soundVol)
			
			end
		


			
			
		end
			
		self.claw:setAnchorPoint(.5, .5)
		self:addChild(self.claw)
		self.claw:setRotation(math.deg(self.angle))

		-- if object was collected

		if(self.scene.holdingObject) then

			-- add the clawObject to claw as child and disable physics
			
			Timer.delayedCall(10, function()
			
				self.scene.theObject.bodyActive = false
				self.scene.theObject.body.disabled = true
				self.scene.theObject.body:setActive(false)
				
				self.claw:addChild(self.scene.theObject)
				self.scene.theObject:setPosition(0,0)
				
				--self.scene.theObject:setPosition(self.scene.playerMovement.heroX,self.scene.playerMovement.heroY)
				
				if(self.scene.theObject.type=="key.png") then
					self.scene.theObject:setRotation(0)
			end
				
		end)

	end

	-- Show particles (like when hits claw blocker)
	
	if(particles) then
	
		-- Use trig to find point
	
		local particlesX = self:getX() + (math.cos(self.angle) * 20)
		local particlesY = self:getY() + (math.sin(self.initialAngle) * 20)
		
		
		if(particles=="creeper bug") then
		
			self.scene.lootParticles.badFruitEmitter:setPosition(particlesX,particlesY)
			self.scene.lootParticles.badFruitEmitter:start()
			
		
		else
		
			-- sparky emitter
			
			self.scene.clawParticles.sparkEmitter:setPosition(particlesX,particlesY)
			--self.scene.clawParticles.sparkEmitter:stop()
			self.scene.clawParticles.sparkEmitter:start()

		end
	
	end
	
	end)
	
	end
	
	Timer.delayedCall(delay, function()

		self.scene.pauseClaw = false
		self.scene.retractingClaw = true
		
		self.scene.heroAnimation:updateAnimation()
		
	end)

end




function Claw:resetClaw()

	self.scene.aimingClaw = false
	self.scene.holdingObject = false
	self.scene.heroAnimation.animation = nil
	self.scene.heroAnimation:updateAnimation()
	self.scene.theObject = nil

end



function Claw:onEnterFrame(Event)

	if(not(self.scene.paused)) then
	
		local armX,armY = self.scene.hero.frontArm:localToGlobal(0, 0) -- get arm coords on stage

		local distXScrolled = -self.scene.rube1:getX()
		local distYScrolled = -self.scene.rube1:getY()

		armXTotal = armX + distXScrolled
		armYTotal = armY + distYScrolled

		-- Work out the angle of claw from hero
			
		local xDiff = self:getX() - armXTotal
		local yDiff = self:getY() - armYTotal

		self.angle = math.atan2(yDiff,xDiff) -- we use the angle of fire until claw is at full reach

		self.scene.hero.frontArm:setRotation(math.deg(self.angle))

		--if(not(self.scene.firingClaw)) then
			--self.body:setAngle(self.angle) -- rotate claw
			--print("set angle")
			self.claw:setRotation(math.deg(self.angle))
		--end
		-- Work out the distance the claw is from ...

		self.distance = math.sqrt((xDiff*xDiff)+(yDiff*yDiff))

		-- set the claw line stuff

		-- line start position

		self.clawLineX = armXTotal+(math.cos(self.angle)*11) - self.scene.hero:getX()
		self.clawLineY = armYTotal+(math.sin(self.angle)*11) - self.scene.hero:getY()
		self.clawLine:setPosition(self.clawLineX, self.clawLineY)

		self.clawLine:setRotation(math.deg(self.angle)-90) -- rotation

		-- Distance went over maxLength
		

		if(self.distance >= (self.maxLength) and self.scene.firingClaw) then

			self:stopAndReturnClaw(300)

		end



		--------------------------------------------------------------
		-- Firing claw
		--------------------------------------------------------------

		if(self.scene.firingClaw) then

			local nextX = self:getX() + (math.cos(self.angle) * self.outSpeed)
			
			local xMove = math.cos(self.initialAngle) * self.outSpeed
			
			local nextX = self:getX() + xMove
			local nextY = self:getY() + (math.sin(self.initialAngle) * self.outSpeed)

			if(self.body) then
				--self.body:setPosition(nextX, nextY)
			end--]]
			
			self.clawLine:setScaleY(self.distance - 24) -- claw line length

		--------------------------------------------------------------
		-- Retracting Claw
		--------------------------------------------------------------
			
		elseif(self.scene.retractingClaw) then
		
			-- flip the angle for return journey
			self.retractAngle = self.angle + (180 * 0.0174532925) -- 1 degrees = 0.0174532925 radians
			
			self.nextX = self:getX() + (math.cos(self.retractAngle) * self.backSpeed)
		
			-- If dragging block, update the block's position
			
			if(self.dragBlock) then
				
				self.stoppingDistance = 5
				self.nextY = self:getY()
				self.dragBlock.body:setPosition(self:getX()+self.clawOffset,self.dragBlock:getY())
				self.backSpeed = 1.5 -- slow claw retract
				
				local bXvel,bYvel = self.dragBlock.body:getLinearVelocity()

				-- Stop dragging if falling
				if(bYvel > 1) then
					
					if(self.dragBlock) then
						
						self.dragBlock.channel1:stop()
	
					end
					
					self.dragBlock.canDrag = false
					self.dragBlock = nil
				end
				
			else
			
				self.nextY = self:getY() + (math.sin(self.retractAngle) * self.backSpeed)
				
			end
			
			-- Update the claw position
			
			self.body:setPosition(self.nextX,self.nextY)

			self.backSpeed = self.backSpeed + .1
			
			self.clawLine:setScaleY(self.distance - 33) -- claw line length
			
		--------------------------------------------------------------
		-- Back at hero, stop
		--------------------------------------------------------------
			
			if(self.distance <= self.stoppingDistance) then
				
				self.stoppingDistance  = 25
				self.backSpeed = 2
				
				if(self.scene.claw.dragBlock) then
					self.scene.claw.dragBlock.channel1:stop()
					self.scene.claw.dragBlock = nil
					
				end
				
				
				
				self.scene.retractingClaw = false
				self.scene.interface.canFire = true
				self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
				self.scene:removeEventListener("onExit", self.onExit, self)	
				self:getParent():removeChild(self)
				self.scene.hero:removeChild(self.clawLine)
				self.scene.heroAnimation:updateAnimation()
			
				
				-- If a rock was in the claw when reached hero
				
				if(self.scene.holdingObject) then

					self.scene.hero.frontArm:addChild(self.scene.theObject)

					if(self.scene.theObject.type=="key.png") then
					
						self.scene.theObject:setX(40)
					
					else
					
						self.scene.theObject:setX(34)
					
					end

				else
				
					self:resetClaw()
					
				end
				
				self.body.destroyed = true
				self.scene.world:destroyBody(self.body) -- remove physics body
				--print(self.scene.heroAnimation.facing,self.scene.hero.frontArm:getScaleX())

		--------------------------------------------------------------
		-- anything in claw?
		--------------------------------------------------------------
				--if(self.scene.lootValue) then
				
				if(self.scene.clawCollected) then
				

					if(self.scene.clawCollected.type == "claw closed mite") then
					

						self.scene.health:reduceHealth(2)
						self.scene.hero:makeInvincible()
						self.scene.hero:miteFace()
						
					elseif(self.scene.clawCollected.type == "sad fruit") then
					
						self.scene.health:reduceHealth(2)
						self.scene.hero:makeInvincible()
						self.scene.loot = self.scene.loot - 10
						self.scene.interface:updateLoot()
						self.scene.hero:makeSad()
						self.scene.lootParticles.badFruitEmitter:start()
						local channel1 = self.scene.splatSound2:play()
						channel1:setVolume(.3*self.scene.soundVol)
						
					else
					
						playSound("Sounds/loot 1.wav",.4*self.scene.soundVol)
						self.scene.loot = self.scene.loot + self.scene.lootValue
						self.scene.interface:updateLoot()
						self.scene.lootParticles.emitter:start()
						self.scene.lootValue = nil

						
					end
					
					--self.scene.firingClaw = false
					self.scene.pauseClaw = false
					self.scene.clawCollected = nil -- clear claw contents
					self.scene.heroAnimation.animation = nil
					self.scene.heroAnimation:updateAnimation()
					--print("update")
					
				end
				
			end

		--------------------------------------------------------------
		-- Claw full extension, paused
		--------------------------------------------------------------

		elseif(self.scene.pauseClaw) then

			self.clawLine:setScaleY(self.distance - 24) -- claw line length

		end
		
		--]]

	-- end if not paused
	end


-- end of enterFrame
end





-- cleanup function

function Claw:onExit()

	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.scene:removeEventListener("onExit", self.onExit, self)

end
