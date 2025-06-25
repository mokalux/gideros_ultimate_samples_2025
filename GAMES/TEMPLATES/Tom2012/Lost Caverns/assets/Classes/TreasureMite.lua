TreasureMite = Core.class(Sprite)

function TreasureMite:init(scene,x,y,id,timeBetweenPoints,delayBetween,easing)

	self.scene = scene
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	self.id = tonumber(id)
	self.type = "claw closed mite"
	self.timeBetweenPoints = timeBetweenPoints -- time taken to move between points
	self.delayBetween = delayBetween
	self.easing = easing

	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)
	anim:setAnimation("TREASURE_MITE")
	anim:setAnimAnchorPoint(.5,.5)
	anim:addToParent(anim)
	anim:playAnimation()
	self:addChild(anim)
	self.anim = anim
	self.scene.frontLayer:addChild(self)
	
	table.insert(self.scene.enemies, self)
	
	-- Add tweens

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
			
			-- bob tween
			
		--	local tween = GTween.new(self, .2, {scaleY=1.1,scaleX=1.1},{ease = easing.none,reflect=true,repeatCount=math.huge})


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

	Timer.delayedCall(1, function()
		local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = true}
		body:setPosition(x,y)
		
		local circle = b2.CircleShape.new(0,0,14)
		local fixture = body:createFixture{shape = circle, density = 1, friction = .1, restitution = .1, isSensor=true}
		
		fixture.name = "mite"
		fixture.parent = self
		self.body = body
		body:setGravityScale(0)

		local filterData = {categoryBits = 4096, maskBits = 8912}
		fixture:setFilterData(filterData)
		--table.insert(self.scene.spritesOnScreen, self)
	end)


	Timer.delayedCall(1000, function() self.canCollect = true end)
	
	self:addEventListener(Event.ENTER_FRAME, self.updateSensor, self)

end




function TreasureMite:pauseAnimation()

	self.anim:pauseAnimation()

end




function TreasureMite:unPauseAnimation()

	self.anim:unPauseAnimation()

end




function TreasureMite:updateSensor()
	
	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
	
		if(self.body) then
			self.body:setPosition(self:getPosition())
		end
	
	end

end




function TreasureMite:collected()

	self:removeEventListener(Event.ENTER_FRAME, self.updateSensor, self)

	self.body.destroyed = true
	Timer.delayedCall(10, function()
	
		self.scene.world:destroyBody(self.body) -- remove physics body
		
		for i,v in pairs(self.scene.enemies) do
			if(v==self) then
				table.remove(self.scene.enemies, i)
			end
		end
		self:getParent():removeChild(self)
	end)
	
	self.scene.interface:updateLoot()
	
	self.scene.clawCollected = self
	self.scene.claw:stopAndReturnClaw(300)

end


function TreasureMite:pause()
	
end



function TreasureMite:resume()

end





-- cleanup function

function TreasureMite:exit()
		
	for i,v in pairs(self.tweens) do
		v:setPaused(true)
	end
	
	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	end
	

end





