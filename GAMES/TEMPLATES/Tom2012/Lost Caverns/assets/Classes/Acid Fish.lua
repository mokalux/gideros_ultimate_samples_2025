AcidFish = Core.class(Sprite)

function AcidFish:init(scene,x,y,yDist,startDelay,delayBetween)

	self.scene = scene
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	self.startDelay = startDelay
	self.delayBetween = delayBetween
	self.yDist = yDist
	self.timeTaken = yDist / 300
	self.y = y

	local anim = CTNTAnimator.new(self.scene.atlas2AnimLoader)

	anim:setAnimation("ACID_FISH_FLYING")

	anim:addToParent(anim)
	

	anim:playAnimation()

	self:addChild(anim)

	self.anim = anim

	self.name = "fish"
	self.scene.layer0:addChild(self)
	
	-- Add tweens
	
	Timer.delayedCall(self.startDelay*1000, self.setupTweens, self)

	self.scene = scene
	self.xSpeed = xSpeed
	self.direction = direction
	table.insert(self.scene.enemies, self)

	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

	local poly = b2.PolygonShape.new()
	poly:setAsBox(12,25,0,2,0)
	local fixture = body:createFixture{shape = poly, density = 1, friction = .2, restitution = 0, isSensor = true}
	
	fixture.parent = self
	fixture.name = "enemy"
	self.body = body
	
	self.body:setLinearDamping(math.huge)

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)

	self:addEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	
	-- sounds
	
	self.maxVolume = .5
	self.volume = 0
	
	if(not(self.scene.fishBiteSound)) then
	
		self.scene.fishBiteSound = Sound.new("Sounds/acid fish bite.wav")

	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	
end



function AcidFish:setupTweens()

	self.upTween = GTween.new(self, self.timeTaken, {y = self.y-self.yDist},{delay=self.delayBetween,ease = easing.outQuadratic})
	self.upTween:addEventListener("complete", self.closeMouth, self)
	self.upTween.dispatchEvents = true
	
	self.downTween = GTween.new(self, self.timeTaken, {y = self.y},{delay=.3,ease = easing.inQuadratic,autoPlay=false})
	
	self.downTween:addEventListener("complete", self.openMouth,self)
	self.downTween.dispatchEvents = true
	
	self.upTween.nextTween = self.downTween
	self.downTween.nextTween = self.upTween
	
end



function AcidFish:pauseAnimation()

	self.anim:pauseAnimation()

end




function AcidFish:unPauseAnimation()

	self.anim:unPauseAnimation()

end



function AcidFish:updateSensor()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
		self.body:setPosition(self:getPosition())
	end
	
end



function AcidFish:openMouth()
	self.anim:setAnimation("ACID_FISH_FLYING")
	self.anim:playAnimation()
end

function AcidFish:closeMouth()
	
	local channel1 = self.scene.fishBiteSound:play()
	channel1:setVolume(self.volume*self.scene.soundVol)

	self.anim:setAnimation("ACID_FISH_BITING")
	Timer.delayedCall(200, self.falling, self)
end

function AcidFish:falling()
	self.anim:setAnimation("ACID_FISH_CLOSED")
	self.anim:setAnimation("ACID_FISH_CLOSED")
	self.anim:playAnimation()
	--]]
end




function AcidFish:pause()

	self.anim:pauseAnimation()
	
end



function AcidFish:resume()

	if(not(self.scene.gameEnded)) then
		self.anim:playAnimation()
	end

end





-- cleanup function

function AcidFish:exit()

	self.upTween:setPaused(true)
	self.downTween:setPaused(true)
	self:removeEventListener(Event.ENTER_FRAME, self.updateSensor, self)
  
end