Saw = Core.class(Sprite)

function Saw:init(scene,x,y,id,timeBetweenPoints,delayBetween,easing)

	self.scene = scene
	self.id = tonumber(id)
	self.timeBetweenPoints = timeBetweenPoints -- time taken to move between points
	self.delayBetween = delayBetween
	self.easing = easing
	
	if(not(self.scene.sawAnimLoader)) then
	
		local atlas = TexturePack.new("Atlases/Saw.txt", "Atlases/Saw.png", true)
		self.scene.atlas['Saw'] = atlas
	
		local animLoader = CTNTAnimatorLoader.new()
		animLoader:loadAnimations("Animations/Saw.tan", self.scene.atlas['Saw'], true)
		self.scene.sawAnimLoader = animLoader
	
	end

	local anim = CTNTAnimator.new(self.scene.sawAnimLoader)
	anim:setAnimation("SAW_MOVE")
	anim:setAnimAnchorPoint(.5,.5)
	anim:addToParent(anim)
	anim:playAnimation()
	self:addChild(anim)
	self.anim = anim
	self.scene.rube2:addChild(self)
	
	self.direction = "left"


	


	Timer.delayedCall(10, function() -- need a delay so that everything is set up
	
		-- Add tweens
	
	self.tweens = {}

		-- Set up the Transitions
		
		local x1 = self.scene.path[self.id].vertices.x[1]
		local y1 = self.scene.path[self.id].vertices.y[1]
		
		local x2 = self.scene.path[self.id].vertices.x[2]
		local y2 = self.scene.path[self.id].vertices.y[2]
		
		self:setPosition(x1,y1)
		
		
		self.tween1 = GTween.new(self, self.timeBetweenPoints, {x = x2,y = y2},{delay=self.delayBetween,ease = easing.outQuadratic})
		self.tween1.dispatchEvents = true
		self.tween1:addEventListener("complete", self.sleep, self)

		
		self.tween2 = GTween.new(self, self.timeBetweenPoints, {x = x1,y = y1},{delay=self.delayBetween,ease = easing.outQuadratic,autoPlay = false})
		self.tween2.dispatchEvents = true
		self.tween2:addEventListener("complete", self.sleep, self)
		
		self.tween1.nextTween = self.tween2
		self.tween2.nextTween = self.tween1

	end)
		
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)

	local circle = b2.CircleShape.new(0,15,35)
	local fixture = body:createFixture{shape = circle, density = 0, friction = 0, restitution = 0, isSensor = true}
	
	fixture.parent = self

	fixture.name = "enemy"
	self.body = body
	
	--self.body:setLinearDamping(math.huge)

	local filterData = {categoryBits = 128, maskBits = 2+4+8}
	fixture:setFilterData(filterData)

	self.body:setGravityScale(0)

	-- sounds
	
	--self.maxVolume = .40
	self.maxVolume = .2
	self.volume = 0
	
	if(not(self.scene.sawSound)) then
	
		self.scene.sawSound = Sound.new("Sounds/saw.wav")

	end
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)

	self:addEventListener(Event.ENTER_FRAME, self.updateSensor, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	self:sleep()
	
end



function Saw:updateSensor()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
		
		self.body:setPosition(self:getPosition())
	
	end

end






function Saw:sleep()

	if(not(self.scene.gameEnded)) then

		self.anim:setAnimation("SAW_SLEEP")
		if(self.channel1) then
			self.channel1:stop()
		end
		self:flip()
		Timer.delayedCall((self.delayBetween*1000-200), self.wake, self)
		
	end

end




function Saw:wake()

	if(not(self.scene.gameEnded)) then

		--local tween = GTween.new(self.channel1, .5, {volume=10})

		self.anim:setAnimation("SAW_HALF")
		Timer.delayedCall(200, function()
		
			self.anim:setAnimation("SAW_MOVE")
			self.anim:playAnimation()
			self.channel1 = self.scene.sawSound:play()
			self.channel1:setVolume(self.volume*self.scene.soundVol)
			
		end)
	
	end

end





function Saw:flip()

	if(self.direction=="left") then
	
		self:setScaleX(-1)
		self.direction = "right"
		
	else
	
		self:setScaleX(1)
		self.direction = "left"
		
	end

end





function Saw:pause()

	self.anim:pauseAnimation()
	
	if(not(self.tween1:isPaused())) then
		self.resumeTween = self.tween1
	else
		self.resumeTween = self.tween2
	end
	
	self.tween1:setPaused(true)
	self.tween2:setPaused(true)
	
end



function Saw:resume()

	if(not(self.scene.gameEnded)) then

		self.anim:playAnimation()
		self.resumeTween:setPaused(false)
	
	end

end



-- cleanup function

function Saw:exit()

	self.tween1:setPaused(true)
	self.tween2:setPaused(true)
	
	self:removeEventListener(Event.ENTER_FRAME, self.updateSensor, self)

	if(self.channel1) then
		self.channel1:setPaused(true)
	end
	self.anim:pauseAnimation()
	
end