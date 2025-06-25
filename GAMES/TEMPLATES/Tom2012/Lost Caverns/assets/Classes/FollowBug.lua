FollowBug = Core.class(Sprite)

function FollowBug:init(scene,x,y,speed,followConstantly)

	self.scene = scene
	self.x = x
	self.y = y
	self.startX = x
	self.startY = y
	
	self.followConstantly = followConstantly
	
		-- Attach bug animation
	
	if(not(self.scene.followBugAnimLoader)) then
	
		local atlas = TexturePack.new("Atlases/Follow Bug.txt", "Atlases/Follow Bug.png", true)
		self.scene.atlas['Follow Bug'] = atlas
	
		local animLoader = CTNTAnimatorLoader.new()
		animLoader:loadAnimations("Animations/Follow Bug.tan", self.scene.atlas['Follow Bug'], true)
		self.scene.followBugAnimLoader = animLoader
	
	end

	local anim = CTNTAnimator.new(self.scene.followBugAnimLoader)
	anim:setAnimation("FOLLOW_BUG_FLYING")
	anim:setAnimAnchorPoint(.5,.5)
	anim:addToParent(anim)
	anim:playAnimation()
	self:addChild(anim)
	self.anim = anim
	self.scene.frontLayer:addChild(self)
	
	self.followSpeed = speed
	self.returnSpeed = speed * 1.3
	
	self.direction = "left"

		
		
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

	local circle = b2.CircleShape.new(5,0,20)
	local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
	
	body.name = "enemy"
	self.body = body
	
	
--	print(body.parent)
	
	self.body:setLinearDamping(math.huge)

	local filterData = {categoryBits = 128, maskBits = 2+4+8}
	fixture:setFilterData(filterData)

	Timer.delayedCall(100, function()
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end)
	
		-- sounds
	
	self.maxVolume = .4
	self.volume = 0
		
	if(not(self.scene.buzzSound)) then
	
		self.scene.buzzSound = Sound.new("Sounds/buzz.wav")
		
	end
	
	-- set up looping sound

	self.channel1 = self.scene.buzzSound:play(0,math.huge)
	self.channel1:setVolume(0)

	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
end





function FollowBug:pauseAnimation()

	self.anim:pauseAnimation()

end




function FollowBug:unPauseAnimation()

	self.anim:unPauseAnimation()

end



function FollowBug:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		-- decide what to do
		
		self.shouldFollow = false
		
		-- If player in follow area
		-- started in Box2D
		
		
		-- In mode where bug follows hero constantly when in area
		
		if(self.followConstantly and self.scene.followHero) then

		
			self:follow()
		
		else
		
			-- mode where bug only follows hero that is moving
		
			if(self.scene.followHero) then
			
				-- Start following hero
				
				if(self.scene.playerMovement.xVel > 3
				or self.scene.playerMovement.xVel < -3
				or self.scene.playerMovement.yVel < -4) then
				
					self:follow()
					
				else
				
					self:returnToStart()
				
				end
				
			
			else
			
				self:returnToStart()
			
			
			end
		
		end
		

		-- Flip section
		
		local x = self:getX()
		
		if(self.previousX) then
			if(x < self.previousX and self.direction=="right") then
				self:flip()
			elseif(x > self.previousX and self.direction=="left") then
				self:flip()
			end
		end
		
		self.previousX = x
	
	end

end




function FollowBug:follow()

	local armX,armY = self.scene.hero.frontArm:localToGlobal(-20, -30) -- get arm coords on stage
	
	-- change to choping anim
	
	self.anim:setAnimation("FOLLOW_BUG_ATTACKING")


	local distXScrolled = 0 - self.scene.rube1:getX()
	local distYScrolled = 0 - self.scene.rube1:getY()

	armXTotal = armX + distXScrolled
	armYTotal = armY + distYScrolled

	-- Work out the angle of claw from hero
		
	local xDiff = self:getX() - armXTotal
	local yDiff = self:getY() - armYTotal

	self.angle = math.atan2(yDiff,xDiff)

	self.retractAngle = self.angle + (180 * 0.0174532925)
			
	self.nextX = self:getX() + (math.cos(self.retractAngle) * self.followSpeed)
	self.nextY = self:getY() + (math.sin(self.retractAngle) * self.followSpeed)
	
	-- Work out the distance I am from hero

	self.distance = math.sqrt((xDiff*xDiff)+(yDiff*yDiff))
	
	if(self.distance > 5 and self.scene.followHero) then
	
		self:setPosition(self.nextX,self.nextY)
		self:updateSensor()
		
	end
	
end




function FollowBug:returnToStart()

	-- Work out the angle of bug from start point
	
		-- change to choping anim
	
	self.anim:setAnimation("FOLLOW_BUG_FLYING")
	
	local xDiff = self:getX() - self.startX
	local yDiff = self:getY() - self.startY

	self.angle = math.atan2(yDiff,xDiff)
	
	self.returnAngle = self.angle + (180 * 0.0174532925)

	local nextX = self:getX() + (math.cos(self.returnAngle) * self.returnSpeed)
	local nextY = self:getY() + (math.sin(self.returnAngle) * self.returnSpeed)

	-- Work out the distance I am from my start position

	local distance = math.sqrt((xDiff*xDiff)+(yDiff*yDiff))
	
	-- Back at start, stop
	
	if(distance > 10) then
		self:setPosition(nextX, nextY)
		self:updateSensor()
	end
	


end





function FollowBug:updateSensor()
	
	self.body:setPosition(self:getPosition())

end





function FollowBug:flip()

	if(self.direction=="left") then
	
		self:setScaleX(-1)
		self.direction = "right"
		
	else
	
		self:setScaleX(1)
		self.direction = "left"
		
	end

end




-- pause function

function FollowBug:pause()

	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self.anim:pauseAnimation()
	
end




-- resume function

function FollowBug:resume()

	if(self.channel1) then
		self.channel1:setPaused(false)
	end
	self.anim:playAnimation()
	
end



function FollowBug:pause()

end




function FollowBug:resume()

end



-- cleanup function

function FollowBug:exit()

	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.anim:pauseAnimation()

end
