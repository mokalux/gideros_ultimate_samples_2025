Box2d = Core.class(Sprite)

function Box2d:init(scene)

	-- Show all collision detect messages
	--local printCollisions = true

	-- Store the scene in this instance's table
	self.scene = scene

	--create world instance
	self.scene.world = b2.World.new(0, 30, true)
	
	-- Create a variable to hold number of hits hero is getting
	self.numberHeroHits = 0

	self.canPlaySound = true
	-- Make the walls

	self:makeWalls(5,self.scene.worldHeight,0,self.scene.worldHeight/2) -- left
	self:makeWalls(5,self.scene.worldHeight,self.scene.worldWidth,self.scene.worldHeight/2) -- right
	self:makeWalls(self.scene.worldWidth,5,self.scene.worldWidth/2,0) -- top
	--self:makeWalls(self.scene.worldWidth,5,self.scene.worldWidth/2,self.scene.worldHeight) -- bottom
	
	-- setup sounds

	self.scene.landSound = Sound.new("Sounds/hero land.wav")


	

	

	-------------------------------------------------------
	--
	-- Contact BEGINS section
	--
	-------------------------------------------------------
	
	local function onBeginContact(event)
	
		-- you can get the fixtures and bodies in this contact like:
		local fixtureA = event.fixtureA
		local fixtureB = event.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()




	


		-- Key hits door

		-- if holding object
		
		if(self.scene.theObject) then
		
			if(fixtureA.name == "key" and fixtureB.name == "keyDoor") then
			
				if(self.scene.keyDoors[self.scene.theObject.id]) then
				
					self.scene.keyDoors[self.scene.theObject.id]:openDoor()
					
				else
				
				fixtureB.parent:shudderAnim()
				self.scene.theObject:destroyKey()
				
					
				end
			
			elseif(fixtureB.name == "key" and fixtureA.name == "keyDoor") then
			
				if(self.scene.keyDoors[self.scene.theObject.id]) then
				
					self.scene.keyDoors[self.scene.theObject.id]:openDoor()
				
				else
	
					self.scene.theObject:destroyKey()
					fixtureA.parent:shudderAnim()
					
				end
			
			end
			
			
		end



		-- Hero enters shy bush

		if (fixtureA.name == "hitbox" and fixtureB.name == "shy bush") then
			
			fixtureB.parent:enterBush()
				
		elseif (fixtureB.name == "hitbox" and fixtureA.name == "shy bush") then
			
			fixtureA.parent:enterBush()
				
		end
		
		
		-- Feet hit ground

		if ((bodyA.name == "Ground" and fixtureB.name == "feet") or (bodyB.name == "Ground" and fixtureA.name == "feet")) then
			
			self:heroOnGround()

		end
		
		
		
		-- hero touches hatch

		if (fixtureA.name == "physics" and bodyB.name2 == "hatch") then
			
			bodyB.parent:touchHatch()

		elseif (fixtureB.name == "physics" and bodyA.name2 == "hatch") then
			
			bodyA.parent:touchHatch()

		end
		
		
		
		-- Wind object spawned on ground

		if(bodyA.name == "Ground" and bodyB.name2 == "windObject" and bodyB.parent.isNew) then
		
			bodyB.parent:killSelf()
			
		elseif(bodyB.name == "Ground" and bodyA.name2 == "windObject" and bodyA.parent.isNew) then
			
			bodyA.parent:killSelf()

		end
		
		
		
				
		-- Wind object spawned on windSafeZone

		if(bodyA.name == "windSafeZone" and bodyB.name2 == "windObject" and bodyB.parent.isNew) then
		
			bodyB.parent:killSelf()
			
		elseif(bodyB.name == "windSafeZone" and bodyA.name2 == "windObject" and bodyA.parent.isNew) then
			
			bodyA.parent:killSelf()

		end
		
		

		
		
		
		-- Bullet hit walls or jump through

		if (bodyA.name == "bullet" and (bodyB.name == "Ground" or bodyB.name == "Jump Through")) then
			
			bodyA.parent:killSelf()
			
		elseif (bodyB.name == "bullet" and (bodyA.name == "Ground" or bodyA.name == "Jump Through")) then
			
			bodyB.parent:killSelf()
			
		end
		
		

		if (bodyA.name == "Jump Through" and fixtureB.name == "jSensor") then
			
			self:heroOnGround()
			self.scene.onJumpThrough = true
			
		elseif(bodyB.name == "Jump Through" and fixtureA.name == "jSensor") then

			self:heroOnGround()
			self.scene.onJumpThrough = true
			
		end

		
		
		-- Feet hit pressure plate

		if (fixtureA.name == "pressure plate" and fixtureB.name == "feet") then
			
			fixtureA.parent:press()
			
		elseif(fixtureA.name == "pressure plate" and fixtureB.name == "feet") then
			
			fixtureB.parent:press()
			
		end
		
		
		-- Coin

		if(fixtureA.name == "hitbox" and fixtureB.name == "coin") then

			if(fixtureB.parent.canCollect) then
				fixtureB.parent:collect()
			end
			
		elseif(fixtureB.name == "hitbox" and fixtureA.name == "coin") then
			fixtureA.parent:collect()

		end
		
		-- health

		if(fixtureA.name == "hitbox" and fixtureB.name == "health") then

			fixtureB.parent:collect()
			
		elseif(fixtureB.name == "hitbox" and fixtureA.name == "health") then
			fixtureA.parent:collect()

		end
		
		
		-- Closing doors hit

		if(bodyA.name2 == "closingDoor" and bodyB.name2 == "closingDoor") then

			bodyA.parent:stop()
			bodyB.parent:stop()

		end
		
		
		
		-- Exit door
		
		if(self.scene.loot >= self.scene.lootBronzeTarget) then
			if(fixtureA.name == "hitbox" and fixtureB.name == "exit door") then
				fixtureB.parent:heroHitDoor()
			elseif(fixtureA.name == "hitbox" and fixtureB.name == "exit door") then
				fixtureA.parent:heroHitDoor()
			end
		end
	
		
		-- JUMPING on something
		
		if(self.scene.playerMovement.yVel > 5) then

		-- Pot

			if(fixtureA.name == "physics" and fixtureB.name == "can hit with butt") then
				fixtureB.parent:stomped()
			elseif(fixtureA.name == "can hit with butt" and fixtureB.name == "physics") then
				fixtureA.parent:stomped()
			end

		

			
		end
		
		
		
		
		-- Hero touching area where bugs follow



		if(bodyA.name == "Hero" and bodyB.name == "followHero") then
			self.scene.followHero = true
		elseif(bodyA.name == "followHero" and bodyB.name == "Hero") then
			self.scene.followHero = true
		end
		
		
		-- In area, triggered spider

		if(bodyA.name == "Hero" and bodyB.name == "dropSpider") then
			self.scene.dropSpiders[bodyB.id]:drop()
		elseif(bodyA.name == "dropSpider" and fixtureB.name == "Hero") then
			self.scene.dropSpiders[bodyA.id]:drop()
		end
		
		
		
		-- Entered wind safe zone

		if(bodyA.name == "Hero" and bodyB.name == "windSafeZone") then
			self.scene.inWindSafeZone = true
		elseif(bodyA.name == "windSafeZone" and fixtureB.name == "Hero") then
			self.scene.inWindSafeZone = true
		end
		
		
		
		-- Hero touched the area that drops door

		if(bodyA.name == "Hero" and bodyB.name == "fadeArt") then

			if(self.scene.idList[bodyB.id]) then
			
				bodyB.faded = true
				for i,v in pairs(self.scene.idList[bodyB.id]) do
					local tween = GTween.new(v, .4, {alpha = 0},{ease = easing.outQuadratic})
				end
			
				
			local channel1 = self.scene.secretAreaSound:play()
			channel1:setVolume(.3*self.scene.soundVol)
			
			bodyB.name = nil

			end

		elseif(bodyA.name == "fadeArt" and bodyB.name == "Hero") then
		
			if(self.scene.idList[bodyA.id]) then
			
				bodyA.faded = true
				for i,v in pairs(self.scene.idList[bodyA.id]) do
					local tween = GTween.new(v, .4, {alpha = 0},{ease = easing.outQuadratic})
			end
			
			local channel1 = self.scene.secretAreaSound:play()
			channel1:setVolume(.3*self.scene.soundVol)
			
			bodyA.name = nil

			end
			
		end
		
		
		
		
		
		-- Hero touched the drop switch trigger

		if(bodyA.name == "Hero" and bodyB.name == "drop switch trigger") then

			bodyB.parent:trigger()

		elseif(bodyA.name == "drop switch trigger" and bodyB.name == "Hero") then
		
			bodyA.parent:trigger()
			
		end
		
		
		
		
		
		
		
		
		-- Hero dropped door

		if(bodyA.name == "Hero" and bodyB.name == "dropDoor") then

			for i,v in pairs(self.scene.dropDoors) do
				v:close()
			end
		elseif(bodyA.name == "dropDoor" and bodyB.name == "Hero") then
			for i,v in pairs(self.scene.dropDoors) do
				v:close()
			end
		end
		
		
		
		
		-- Flying saw touched ground (bounced off)

		if(bodyA.name == "flying saw" and bodyB.name == "Ground") then

			bodyA.parent:bounce()
			
		elseif(bodyB.name == "flying saw" and bodyA.name == "Ground") then
		
			bodyB.parent:bounce()
		
		end
		
		
		
		
		
		
		
		
		-- Hero touched area that makes door start slowly closing

		if(bodyA.name == "Hero" and bodyB.name == "closeDoor") then

			if(self.scene.idList[bodyB.id]) then
			
				if(self.scene.idList[bodyB.id]) then
					for i,v in pairs(self.scene.idList[bodyB.id]) do
						v:close()
					end
				end
			
			bodyB.name = nil

			end
			
		elseif(bodyA.name == "closeDoor" and bodyB.name == "Hero") then
		
				if(self.scene.idList[bodyA.id]) then
					for i,v in pairs(self.scene.idList[bodyA.id]) do
						v:close()
					end
				end
			
			bodyA.name = nil
			
		end
		
		
		
		----------------------------------------------------------------
		-- Claw is firing and hits something
		----------------------------------------------------------------
		
		if(self.scene.firingClaw) then
		
			-- Claw hit loot

			if(fixtureA.name == "claw" and fixtureB.name == "loot") then
				fixtureB.parent:collected()
	
			elseif(fixtureA.name == "loot" and fixtureB.name == "claw") then
				fixtureA.parent:collected()

			end
			
			
			--[[
			-- Claw hit flying bug with loot

			if(fixtureA.name == "claw" and fixtureB.name == "loot") then
				fixtureB.parent:collected()

			elseif(fixtureA.name == "loot" and fixtureB.name == "claw") then
				fixtureA.parent:collected()
			end
--]]
		
		
		-- Claw hit mite

			if(fixtureA.name == "claw" and fixtureB.name == "mite") then
				fixtureB.parent:collected()
			elseif(fixtureA.name == "mite" and fixtureB.name == "claw") then
				fixtureA.parent:collected()
			end

		
		
			-- Claw hit drag block

			if(fixtureA.name == "claw" and fixtureB.name == "block") then
				fixtureB.parent:attachToClaw()
			elseif(fixtureA.name == "block" and fixtureB.name == "claw") then
				fixtureA.parent:attachToClaw()
			end

			
			
			-- Claw hit eye

			if(fixtureA.name == "claw" and fixtureB.name == "eye") then
				fixtureB.parent:attachToClaw()
			elseif(fixtureA.name == "eye" and fixtureB.name == "claw") then
				fixtureA.parent:attachToClaw()
			end
			
			
			-- Claw hit crystal

			if(fixtureA.name == "crystal" and fixtureB.name == "claw") then
				fixtureA.parent:harvest()
			elseif(fixtureA.name == "claw" and fixtureB.name == "crystal") then
				fixtureB.parent:harvest()
			end
			
			
			
			-- Claw hit claw object

			if(fixtureA.name == "claw object" and fixtureB.name == "claw") then
				fixtureA.parent:attachToClaw()
			elseif(fixtureA.name == "claw" and fixtureB.name == "claw object") then
				fixtureB.parent:attachToClaw()
			end
			
			
			-- Claw hit clawBlock wall (stop and return)

			if(bodyA.name == "clawBlock" and bodyB.name == "claw") then
				self.scene.claw:stopAndReturnClaw(50,true,true)
				--fixtureA.parent:attachToClaw()
			elseif(bodyA.name == "claw" and bodyB.name == "clawBlock") then
				--fixtureB.parent:attachToClaw()
				self.scene.claw:stopAndReturnClaw(50,true)
			end
			
		-- end claw firing
		end


		
		
		-- Hero hit follow hero sensor (makes things follow hero

		if ((fixtureA.name == "hitbox" and fixtureB.name == "follow hero sensor") or (fixtureB.name == "hitbox" and fixtureA.name == "follow hero sensor")) then

			if(fixtureA.name == "follow hero sensor") then
				fixtureA.parent:makeFollow()
			else
				fixtureB.parent:makeFollow()
			end
		end
		
		
		-- Thwomper hit walking chest

		if ((fixtureA.name == "masher" and fixtureB.name == "walking chest") or (fixtureB.name == "masher" and fixtureA.name == "walking chest")) then
			if(fixtureA.name == "walking chest") then
				fixtureA.parent:crushed()
			else
				fixtureB.parent:crushed()
			end
		end
		
		-- Rolling skull hit walking chest
		
		if (bodyA.name == "masherUpDown2" and bodyB.name == "changeDirection") then
			bodyA.parent:changeDirection()
		elseif (bodyB.name == "masherUpDown2" and bodyA.name == "changeDirection") then
			bodyB.parent:changeDirection()
		end
	
	
	
		-- Masher up down 2 hit changeDirection
		
		if ((fixtureA.name == "skull" and fixtureB.name == "walking chest") or (fixtureB.name == "skull" and fixtureA.name == "walking chest")) then
			if(fixtureA.name == "walking chest") then
				fixtureB.parent:killSelf()
				fixtureA.parent:crushed()
			else
				fixtureA.parent:killSelf()
				fixtureB.parent:crushed()
			end
		end
	
	
	
		--------------------------------------------------------
		-- Hero hitbox hit monster or dangerous object
		--------------------------------------------------------
		
		-- Enemy
		
		if(
		(fixtureB.name == "hitbox" and bodyA.name=="enemy")
		or (fixtureA.name == "hitbox" and bodyB.name=="enemy")
		or (fixtureA.name == "hitbox" and fixtureB.name=="enemy")
		or (fixtureB.name == "hitbox" and fixtureA.name=="enemy")
		) then

				self.numberHeroHits = self.numberHeroHits +1
				self.damage = 2
				
		end

		
		
		-- Hero hit something dangerous

		if (bodyA.name == "Hero" and bodyB.name == "danger") then
		
			self.numberHeroHits = self.numberHeroHits +1
			self.damage = 2
			
			if(bodyB.actAsGround) then
				self:heroOnGround()
			end
			
		elseif(bodyA.name == "danger" and bodyB.name == "Hero") then
			
			--self.spikesX, self.spikesY = bodyB:getPosition()
			self.numberHeroHits = self.numberHeroHits +1
			self.damage = 2
			if(bodyA.actAsGround) then
				self:heroOnGround()
			end

		end
		
		
		
		
		
		-- Hero hit acid

		if (bodyA.name == "Hero" and bodyB.name == "acid")  then
		
			self.numberHeroHits = self.numberHeroHits +1
			self.damage = 2
			
			-- bounce up
			self.scene.hero.body:setLinearVelocity(self.scene.playerMovement.xVel, -10)
			
		elseif(bodyA.name == "acid" and bodyB.name == "Hero") then

			self.numberHeroHits = self.numberHeroHits +1
			self.damage = 2
			
			-- bounce up
			self.scene.hero.body:setLinearVelocity(self.scene.playerMovement.xVel, -10)

		end
		
		
		
		-- Ball hit ball killer or other skull
		
		if (bodyA.name2 == "ball" and bodyB.name == "removeInstance") then

			bodyA.parent:killSelf()

		elseif(bodyB.name2 == "ball" and bodyA.name == "removeInstance") then
			
			bodyB.parent:killSelf()
			
		elseif(bodyA.name2 == "ball" and bodyB.name2 == "skull buster") then

			bodyA.parent:killSelf()

		elseif(bodyB.name2 == "ball" and bodyA.name2 == "skull buster") then
			
			bodyB.parent:killSelf()

		end
		
		
		
		
		-- Drag block hit button
		
		if (fixtureA.name == "drag block button" and fixtureB.name == "block") then
			
			if(not(fixtureA.parent.pressed)) then
				fixtureA.parent:lowerButton()
			end

		elseif(fixtureB.name == "drag block button" and fixtureA.name == "block") then
			
			if(not(fixtureB.parent.pressed)) then
				fixtureB.parent:lowerButton()
			end

		end
		
		
		
		
		-- Claw Object hit Block Spike
		
		if(fixtureA.name == "claw object" and fixtureB.name == "block spike") then
			
			if(fixtureA.parent.canHit) then
				fixtureB.parent:open()
			end

		elseif(fixtureB.name == "claw object" and fixtureA.name == "block spike") then

			if(fixtureB.parent.canHit) then
				fixtureA.parent:open()
			end
		end
		
		
		
		
		-- Claw Object hit enemy
		
		if(fixtureA.name == "claw object" and fixtureB.name == "enemy") then
			
			if(fixtureA.parent.canHit) then
				fixtureB.parent:hit(1,fixtureA.parent)
			end

		elseif(fixtureB.name == "claw object" and fixtureA.name == "enemy") then

			if(fixtureB.parent.canHit) then
				fixtureA.parent:hit(1,fixtureB.parent)
			end
		end

		

		
		

		if(printCollisions) then
			print("begin contact: ", bodyA.name, "<->", fixtureB.name )
		end
		
		
	-- end begin collision
	
	end







-------------------------------------------------------
--
-- Contact ENDS section
--
-------------------------------------------------------


	local function onEndContact(event)
	
		-- you can get the fixtures and bodies in this contact like:
		local fixtureA = event.fixtureA
		local fixtureB = event.fixtureB
		local bodyA = fixtureA:getBody()
		local bodyB = fixtureB:getBody()
		
		
		-- Exit wind safe zone

		if(bodyA.name == "Hero" and bodyB.name == "windSafeZone") then
			self.scene.inWindSafeZone = nil
		elseif(bodyA.name == "windSafeZone" and fixtureB.name == "Hero") then
			self.scene.inWindSafeZone = nil
		end
		



		-- Hero exits shy bush

		if (fixtureA.name == "hitbox" and fixtureB.name == "shy bush") then
			
			fixtureB.parent:exitBush()
				
		elseif (fixtureB.name == "hitbox" and fixtureA.name == "shy bush") then
			
			fixtureA.parent:exitBush()
				
		end
		
		
		-- Hero touching area where bugs follow

		if(bodyA.name == "Hero" and bodyB.name == "followHero") then
			self.scene.followHero = false
		elseif(bodyA.name == "followHero" and bodyB.name == "Hero") then
			self.scene.followHero = false
		end
		
		
		-- Walking chest sensor

		if ((fixtureA.name == "hitbox" and fixtureB.name == "follow hero sensor") or (fixtureB.name == "hitbox" and fixtureA.name == "follow hero sensor")) then
			if(fixtureA.name == "follow hero sensor") then
				fixtureA.parent:stopFollow()
			else
				fixtureB.parent:stopFollow()
			end
		end
		
		
		
		-- Exit door
		
		if(self.scene.doorOpen) then
			if(fixtureA.name == "hitbox" and fixtureB.name == "exit door") then
				fixtureB.parent:heroMovedOffDoor()
			elseif(fixtureA.name == "hitbox" and fixtureB.name == "exit door") then
				fixtureA.parent:heroMovedOffDoor()
			end
		end
		
		
		
		-- Feet left pressure plate

		if (fixtureA.name == "pressure plate" and fixtureB.name == "feet") then
			
			fixtureA.parent:depress()
			
		elseif(fixtureA.name == "pressure plate" and fixtureB.name == "feet") then
			
			fixtureB.parent:depress()
			
		end






		-- Hero hitbox hit monster or dangerous object
		
		-- Enemy
		
		if(
		(fixtureB.name == "hitbox" and bodyA.name=="enemy")
		or (fixtureA.name == "hitbox" and bodyB.name=="enemy")
		or (fixtureA.name == "hitbox" and fixtureB.name=="enemy")
		or (fixtureB.name == "hitbox" and fixtureA.name=="enemy")
		) then

			self.numberHeroHits = self.numberHeroHits -1

		end
		
		
		
		-- Acid - end contact

		if ((bodyA.name == "Hero" and bodyB.name == "acid") or (bodyA.name == "acid" and bodyB.name == "Hero"))  then
		
			self.numberHeroHits = self.numberHeroHits -1

		end
		

		

		
		-- Hero / spikes

		if (bodyA.name == "Hero" and bodyB.name == "danger") then
		
			self.numberHeroHits = self.numberHeroHits -1
			
			if(bodyB.actAsGround) then
				self:heroLeftGround()
			end
			
			
			
		elseif(bodyA.name == "danger" and bodyB.name == "Hero") then
			
			self.numberHeroHits = self.numberHeroHits -1
			
			if(bodyA.actAsGround) then
				self:heroLeftGround()
				
			end

		end
		
		
		

		
		-- Feet

		if ((bodyA.name == "Ground" and fixtureB.name == "feet") or (bodyB.name == "Ground" and fixtureA.name == "feet")) then
	
			self:heroLeftGround()
			self.scene.onJumpThrough = false

		end
		

		if ((bodyA.name == "Jump Through" and fixtureB.name == "jSensor") or (bodyB.name == "Jump Through" and fixtureA.name == "jSensor")) then
	
			self:heroLeftGround()
			self.scene.onJumpThrough = false
			
		end



		

	end




	-- register 4 physics events with the world object
	self.scene.world:addEventListener(Event.BEGIN_CONTACT, onBeginContact)
	self.scene.world:addEventListener(Event.END_CONTACT, onEndContact)
	

	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	-- end init
end



-- Function to make the walls

function Box2d:makeWalls(w,h,x,y)

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,fixedRotation = true}

	local poly = b2.PolygonShape.new()
	poly:setAsBox(w/2,h/2,0,0,0)
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0}
	local filterData = {categoryBits = 2, maskBits = 1+4+128}
	fixture:setFilterData(filterData)
	body:setPosition(x,y)
	body.name = "ground"

end


function Box2d:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

	-- edit the step values if required. These are good defaults!
	self.scene.world:step(1/60, 8, 3)

		-- Move each sprite on screen

		for i,v in pairs(self.scene.spritesOnScreen) do

			local sprite = v

			local body = sprite.body
			
			if(body) then
				if(not body.destroyed) then

					if(not(body.disabled)) then -- if we haven't disabled physics
						local bodyX, bodyY = body:getPosition()
						sprite:setPosition(bodyX, bodyY)
						sprite:setRotation(body:getAngle() * 180 / math.pi)
					end
				else
					-- the body has been removed, we dont need this sprite in the table any more
					table.remove(self.scene.spritesOnScreen,i)
				end
			end

		end
		
		
	-- End if not paused or game ended		
	end

	-- Update camera
	self.scene.camera:update()
	
	-- If the hero is being hit then do something!
	
	if(self.numberHeroHits > 0 and not(self.scene.hero.invincible) and not(self.scene.hero.dead)) then

		self.scene.hero:gotHit(2)
		
	end

-- End on enterframe loop
end



--]]



function Box2d:pause()


end




function Box2d:resume()


end



function Box2d:exit()

	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end



function Box2d:heroOnGround()

	--if(self.scene.playerMovement.numFeetContacts==0) then

		self.scene.touchingGround = true 
		self.scene.hero.falling = false
		self.scene.playerMovement.numFeetContacts = self.scene.playerMovement.numFeetContacts + 1
		self.scene.heroAnimation:updateAnimation()
		
		self.scene.interface:stopMovingUp()
		
		if(self.canPlaySound) then
			
			if(self.scene.playerMovement.yVel > 4) then
				local channel1 = self.scene.landSound:play()
				if(channel1) then
					channel1:setVolume(.4*self.scene.soundVol)
				end
				self.canPlaySound = false
				Timer.delayedCall(50, function() self.canPlaySound = true end)
			end

			
		end
		
		
		
	--end

end


function Box2d:heroLeftGround()

	self.scene.playerMovement.numFeetContacts = self.scene.playerMovement.numFeetContacts - 1
	
	if(self.scene.playerMovement.numFeetContacts<0) then
		self.scene.playerMovement.numFeetContacts = 0
	end

end


