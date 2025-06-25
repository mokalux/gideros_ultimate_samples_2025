FlyingSaw = Core.class(Sprite)

function FlyingSaw:init(scene,x,y,id,timeBetweenPoints,delayBetween,easing,followHero,speed,followConstantly,atlas)

	-- NOTE if this image has an id, then it will follow a path, if not it will bounce off edges

	self.scene = scene
	self.id = tonumber(id)
	self.timeBetweenPoints = timeBetweenPoints -- time taken to move between points
	self.delayBetween = delayBetween
	self.easing = easing
	self.speed = speed
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("flying saw blades.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	
	local tween = GTween.new(img, 1.5, {rotation = 360},{repeatCount = math.huge})

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("flying saw body.png"))
	img:setAnchorPoint(.49,.5)
	self:addChild(img)
	img:setRotation(-5)
	
	local tween = GTween.new(img, .5, {rotation = 10},{ease = easing.inOutQuadratic, reflect = true,repeatCount = math.huge})
	
	self.scene.rube2:addChild(self)
	
	table.insert(self.scene.enemies, self) -- used for transitions
	
	self.tweens = {} -- create table to store tweens
	
	Timer.delayedCall(10, self.setUpTransitions, self)
		
	-- Add physics

	local body = self.scene.world:createBody{type = b2.DYNAMIC_BODY,allowSleep = false}
	body:setPosition(x, y)
	body.name = "flying saw"

	local shape = b2.CircleShape.new(0,0,40)
	local fixture = body:createFixture{shape = shape, density = 1, friction = 0, restitution = 1}
	
	fixture.parent = self
	fixture.name = "enemy"
	self.body = body
	body.parent = self
	
	
	body:setGravityScale(0)

	if(self.id) then
		self.filterData = {categoryBits = 128, maskBits = 8}
	else
		self.filterData = {categoryBits = 128, maskBits = 2+8}
	end
	

	fixture:setFilterData(self.filterData)
	body:setLinearVelocity(0,5)

	
	-- sounds
	
	self.maxVolume = .2
	self.volume = 0
		
	if(not(self.scene.chainsawSound1)) then
	
		self.scene.chainsawSound1 = Sound.new("Sounds/chainsaw 1.wav")

	end
	

	if(not(self.id)) then
		table.insert(self.scene.spritesOnScreen, self) -- move sprite with body
		table.insert(self.scene.spritesWithVolume, self)
	else

		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

	end
	
	self.scene:addEventListener("onExit", self.onExit, self)


end





function FlyingSaw:setUpTransitions()

	if(self.id) then
	self.tweenCount = 0

		self.tweens = {} -- create table to store tweens
		
		-- Set up the Transitions

		for i = #self.scene.path[self.id].vertices.x,1,-1 do
		
			local nextX = self.scene.path[self.id].vertices.x[i]
			local nextY = self.scene.path[self.id].vertices.y[i]
			
			self.tweenCount = self.tweenCount + 1
			
			if(i == #self.scene.path[self.id].vertices.x) then
			
				if(self.easing=="outQuadratic") then
					self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.outQuadratic})
				else
					self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.none})
				end
			else
				if(self.easing=="outQuadratic") then
					self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.outQuadratic,autoPlay = false})
				else
					self.tweens[self.tweenCount] = GTween.new(self, self.timeBetweenPoints, {x = nextX,y = nextY},{delay=self.delayBetween,ease = easing.none,autoPlay = false})
				end
				
			end
			
		end


		-- Set up the next tweens
		
		for i = 1,#self.tweens do

			local nextTweenNum = i+1
			
			-- if there are no more tweens
			
			if(i == #self.tweens) then

				self.tweens[i].nextTween = self.tweens[1]
			
			else
			
				self.tweens[i].nextTween = self.tweens[nextTweenNum]
				
			end

		end

	end
end




function FlyingSaw:bounce()

	--print("bounce")
	
	if(not(self.soundPlaying)) then
	
		self.soundPlaying = true
		
		Timer.delayedCall(100, self.canPlayAgain, self)
		
		self.channel1 = self.scene.chainsawSound1:play()
		self.channel1:setVolume(self.volume*self.scene.soundVol)
	
	end

end



function FlyingSaw:canPlayAgain()
	
	self.soundPlaying = false

end




function FlyingSaw:onEnterFrame()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		self.body:setPosition(self:getPosition())
	
	end

end






function FlyingSaw:pauseAnimation()

	--self.anim:pauseAnimation()

end




function FlyingSaw:unPauseAnimation()

	--self.anim:unPauseAnimation()

end



-- cleanup function

function FlyingSaw:onExit()

	if(self.tweens) then
		for i,v in pairs(self.tweens) do
			v:setPaused(true)
		end
	end
	

	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end
	
	self.scene:removeEventListener("onExit", self.onExit, self)

end