FlyingWraith = Core.class(Sprite)

function FlyingWraith:init(scene,x,y,id,timeBetweenPoints,delayBetween,easing,followHero,speed,followConstantly,radius)

	if(not(radius)) then
		self.radius = 180
	else
		self.radius = radius
	end

	self.scene = scene
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	self.id = tonumber(id)
	self.timeBetweenPoints = timeBetweenPoints -- time taken to move between points
	self.delayBetween = delayBetween
	self.easing = easing
	self.speed = speed
	self.followHero = followHero
	self.followConstantly = followConstantly
	
	if(not(self.scene.flyingWraithAnimLoader)) then
	
		local atlas = TexturePack.new("Atlases/Flying Wraith.txt", "Atlases/Flying Wraith.png", true)
		self.scene.atlas['Flying Wraith'] = atlas
	
		local animLoader = CTNTAnimatorLoader.new()
		animLoader:loadAnimations("Animations/Flying Wraith.tan", self.scene.atlas['Flying Wraith'], true)
		self.scene.flyingWraithAnimLoader = animLoader
	
	end
	
		
	local anim = CTNTAnimator.new(self.scene.flyingWraithAnimLoader)
	anim:setAnimation("FLYING_WRAITH")
	anim:addToParent(anim)
	anim:playAnimation()
	self:addChild(anim)
	self.anim = anim
	
	self.scene.rube2:addChild(self)
	
	self.facing = "left"
	
	table.insert(self.scene.enemies, self) -- used for transitions
	
	-- dont plot points if this is a following wraith
	
	if(not(followHero)) then
	
		self.tweens = {} -- create table to store tweens
		
		Timer.delayedCall(10, function() -- need a delay so that everything is set up

			-- Set up the Transitions
			
				for i=1,#self.scene.path[self.id].vertices.x do
				
					local nextX = self.scene.path[self.id].vertices.x[i]
					local nextY = self.scene.path[self.id].vertices.y[i]
					
					
					
					if(i==1) then
					
						if(self.easing=="outQuadratic") then
							self.tweens[i] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.outQuadratic})
						else
							self.tweens[i] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.none})
						end
					else
						if(self.easing=="outQuadratic") then
							self.tweens[i] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.outQuadratic,autoPlay = false})
						else
							self.tweens[i] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.none,autoPlay = false})
						end
						
					end
					
				end


			-- Set up the next tweens
			
			for i=1,#self.tweens do

				local nextTweenNum = i+1
				
				-- if there are no more tweens
				
				if(i == #self.tweens) then

					self.tweens[i].nextTween = self.tweens[1]
				
				else
				
					self.tweens[i].nextTween = self.tweens[nextTweenNum]
					
				end

			end

		end)
		
	-- sounds
	

	self.maxVolume = .155
	self.volume = 0
		
	if(not(self.scene.ghostSound)) then
	
		self.scene.ghostSound = Sound.new("Sounds/flying wraith wings.wav")
		
	end
	
	self:playSound()
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	end
	

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

--	local poly = b2.PolygonShape.new()


	--poly:setAsBox(40,40,0,10,0)
	
	local circle = b2.CircleShape.new(0,14,50)
	local fixture = body:createFixture{shape = circle, density = 1, friction = .2, restitution = 0, isSensor = true}
	
	fixture.parent = self
	fixture.name = "enemy"
	self.body = body
	
	body:setGravityScale(0)

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)


	
	if(followHero) then
	
		-- Near to sensor
		
		local circle = b2.CircleShape.new(0,0,self.radius)

		local fixture = body:createFixture{shape =circle, density = 0, friction = 0, restitution = 0, isSensor=true}
		local filterData = {categoryBits = 2048, maskBits = 8}
		fixture:setFilterData(filterData)
		fixture.name = "follow hero sensor"
		fixture.parent = self
		
		table.insert(self.scene.spritesOnScreen, self) -- move sprite with body
		
	end
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end




function FlyingWraith:playSound()

	self.channel1 = self.scene.ghostSound:play(0,math.huge)
	self.channel1:setVolume(0)

end



function FlyingWraith:pauseAnimation()

	self.anim:pauseAnimation()

end




function FlyingWraith:unPauseAnimation()

	self.anim:unPauseAnimation()

end



function FlyingWraith:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		if(self.shouldFollow) then
			
			self:follow()
		
		end
		
		self:checkDirection()
		
		if(not(self.followHero)) then
			self:updateSensor()
		end
	
	end

end






function FlyingWraith:updateSensor()
	
	self.body:setPosition(self:getPosition())

end




function FlyingWraith:makeFollow()

	self.shouldFollow = true

end




function FlyingWraith:stopFollow()

	if(not(self.followConstantly)) then -- keep following once starts following
	
		self.shouldFollow = false
	end

end





function FlyingWraith:follow()

	local armX,armY = self.scene.hero.frontArm:localToGlobal(-20, -30) -- get arm coords on stage

	local distXScrolled = 0 - self.scene.rube1:getX()
	local distYScrolled = 0 - self.scene.rube1:getY()

	armXTotal = armX + distXScrolled
	armYTotal = armY + distYScrolled

	-- Work out the angle of claw from hero
		
	local xDiff = self:getX() - armXTotal
	local yDiff = self:getY() - armYTotal

	self.angle = math.atan2(yDiff,xDiff)

	local followAngle = self.angle + (180 * 0.0174532925)
	
	local x,y = self.body:getPosition()

	self.nextX = x + (math.cos(followAngle) * self.speed)
	self.nextY = y + (math.sin(followAngle) * self.speed)
	
	-- Work out the distance I am from hero

	self.distance = math.sqrt((xDiff*xDiff)+(yDiff*yDiff))
	
	if(self.distance > 5) then
	
		self.body:setPosition(self.nextX,self.nextY)

	end

end










function FlyingWraith:checkDirection()

	if(self.previousX) then
	
		local x = self:getX()
		
		if(x > self.previousX and self.facing=="left") then
			self:turnRight()
		elseif(x < self.previousX and self.facing=="right") then
			self:turnLeft()
		end
	end
	
	self.previousX = self:getX()
	
end



function FlyingWraith:turnLeft()

	self.facing = "left"
	self.anim:setAnimation("FLYING_WRAITH_TURN")
	
	Timer.delayedCall(100, function()
		self:setScaleX(1)
		self.anim:setAnimation("FLYING_WRAITH")
	end)
	
end




function FlyingWraith:turnRight()

	self.facing = "right"
	self.anim:setAnimation("FLYING_WRAITH_TURN")
	
	Timer.delayedCall(100, function()
		self:setScaleX(-1)
		self.anim:setAnimation("FLYING_WRAITH")
	end)

end



-- pause function

function FlyingWraith:pause()

	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	
	self.anim:pauseAnimation()
	
end




-- resume function

function FlyingWraith:resume()

	if(self.channel1) then
		self.channel1:setPaused(false)
	end
	
	self.anim:playAnimation()
	
end



-- cleanup function

function FlyingWraith:exit()

	if(self.tweens) then
		for i,v in pairs(self.tweens) do
			v:setPaused(true)
		end
	end

	self.anim:pauseAnimation()
	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end