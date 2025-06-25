CarryBug = Core.class(Sprite)

function CarryBug:init(scene,x,y,image,id,timeBetweenPoints,delayBetween)

	self.scene = scene
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	self.x = x
	self.y = y
	self.id = id
	self.timeBetweenPoints = timeBetweenPoints -- time taken to move between points
	self.delayBetween = delayBetween
	self.scene.rube2:addChild(self)
	
	
	self.vMoveCounter = 0
	self.vMax = 20
	self.vMove = .5 
	self.vMovePos = self.vMove
	
	self.theBug = Sprite.new()
	self:addChild(self.theBug)
		
	
	-- attach right loot
	
	if(image=="gold 1.png") then
	
		self.loot = Loot.new(self.scene,"gold 1.png",10, "fly gold",20,20,"yes")
		
	elseif(image=="gold 3.png") then
	
		self.loot = Loot.new(self.scene,"gold 3.png",30, "fly gold",20,20,"yes")
		
	elseif(image=="gold 4.png") then
	
		self.loot = Loot.new(self.scene,"gold 4.png",40, "fly gold",20,20,"yes")
		
	end
	

	self.theBug:addChild(self.loot)
	
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
	self.theBug:addChild(anim)
	self.anim = anim
	
	self.facing = "left"

	self.tweens = {} -- create table to store tweens
	
	table.insert(self.scene.enemies, self)

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

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(x, y)
	
	-- Hit box

	local poly = b2.PolygonShape.new()
	poly:setAsBox(20,16,0,10,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0}
	
	fixture.parent = self
	fixture.loot = 	self.loot
	fixture.name = "enemy"
	self.body = body
	
	self.body:setGravityScale(0)

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	-- Collect loot collision shape
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(17,15,10,13,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0}
	
	fixture.parent = self
	fixture.name = "loot"
	self.body = body

	local filterData = {categoryBits = 4096, maskBits = 8192}
	fixture:setFilterData(filterData)
	
	-- sounds
	
	self.maxVolume = .4
	self.volume = 0
		
	if(not(self.scene.buzzSound)) then
	
		self.scene.buzzSound = Sound.new("Sounds/buzz.wav")
		
	end
	
	self.channel1 = self.scene.buzzSound:play(0,math.huge)
	self.channel1:setVolume(0)
	
	-- add channel to table for volume by distance
	
	table.insert(self.scene.spritesWithVolume, self)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	

end








function CarryBug:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		self:updateSensor()
		self:checkDirection()
		self:bob()
	
	end

end



function CarryBug:bob()

	if(self.vMoveCounter >= self.vMax) then

		self.vMove = self.vMove * -1
		self.vMoveCounter = 0
	end

	local x,y = self.theBug:getPosition()
	
	self.vMoveCounter = self.vMoveCounter + self.vMovePos
	self.theBug:setPosition(x,y+self.vMove)

end


function CarryBug:collected()

	if(not(self.isCollected)) then
		self.isCollected = true
		self.loot:collected()
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		
		self.body.destroyed = true
		Timer.delayedCall(10, function()
			self.scene.world:destroyBody(self.body) -- remove physics body
		end)
		
		
		for i,v in pairs(self.tweens) do
			v:setPaused(true)
		end
		 

		local tween = GTween.new(self, 5, {y = self:getY()-500, x = self:getX()+math.random(-200,200)},{ease = easing.outQuadratic})
		Timer.delayedCall(5000, self.killSelf, self)
		self:removeFromVolume()
		self.channel1:setPaused(true)
		

	end

end


function CarryBug:killSelf()

	local tween = GTween.new(self, .5, {alpha=0})
	Timer.delayedCall(500, function()
		self:getParent():removeChild(self)
	end)
	
	self:removeFromVolume()

end





function CarryBug:updateSensor()
	
	local x,y = self:getPosition()
	self.body:setPosition(x,y+self.theBug:getY())
	
end




function CarryBug:checkDirection()

	if(self.previousX) then
	
		local x = self:getX()
		
		if(x > self.previousX and self.facing=="left") then
			self:flip()
			self.facing="right"
		elseif(x < self.previousX and self.facing=="right") then
			self:flip()
			self.facing="left"
		end
	end
		self.previousX = self:getX()
end



function CarryBug:flip()

	self:setScaleX(self:getScaleX()*-1)

end







function CarryBug:removeFromVolume()

	for i,v in pairs(self.scene.spritesWithVolume) do
		if(v==self) then
			table.remove(self.scene.spritesWithVolume, i)
		end
	end

end






function CarryBug:pause()

	self.anim:pauseAnimation()
	
end



function CarryBug:resume()

	if(not(self.scene.gameEnded)) then
		self.anim:playAnimation()
	end

end











function CarryBug:exit()

	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
	self.anim:pauseAnimation()
	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

end
