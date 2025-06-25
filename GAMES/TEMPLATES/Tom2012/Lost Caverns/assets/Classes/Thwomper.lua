Thwomper = Core.class(Sprite)

function Thwomper:init(scene,x,y,startDelay,upSpeed,downSpeed,delayBetween,file)

	self.speed = speed
	self.posSpeed = downSpeed
	self.phase = "up"
	self.delayBetween = delayBetween
	self.distanceCounter = 0
	self.scene = scene
	self.upSpeed = upSpeed
	self.downSpeed = downSpeed
	self.startY = y
	self.x = x
	self.y = y
	self.image = file
	
	Timer.delayedCall(startDelay*1000, self.create, self)

	-- sounds
	
	self.maxVolume = .15
	self.volume = 0
		
	if(not(self.scene.thwompSound)) then
	
		self.scene.thwompSound = Sound.new("Sounds/thwomper hit.wav")
		self.scene.liftSound = Sound.new("Sounds/ratchet.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.liftSound:play(0,math.huge,true)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)

end



function Thwomper:create()

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion(self.image));
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.layer0:addChild(self)
	self.img = img
	
	-- Thwomper body

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(self.x, self.y)
	self.body = body
	

	local poly = b2.PolygonShape.new()
	poly:setAsBox(36,40,-2,-30,0)
	
	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}

	fixture.parentSprite = self
	fixture.name = "masher"
	self.mainFixture = fixture
	self.body = body
	self.body.name = "Ground"

	local filterData = {categoryBits = 2, maskBits = 1+256}
	fixture:setFilterData(filterData)
	

	shape = b2.CircleShape.new(-2,30,36)
	local fixture = body:createFixture{shape = shape, density = 999999, friction = 0, restitution = 0}

	fixture.parentSprite = self
	fixture.name = "masher"
	self.mainFixture = fixture
	self.body = body
	self.body.name = "Ground"

	local filterData = {categoryBits = 2, maskBits = 1+256}
	fixture:setFilterData(filterData)



	-- Thwomper stinger - the bit that hurst hero

	local poly = b2.PolygonShape.new()
	poly:setAsBox(30,9,0,60,0)
	
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0, isSensor = true}
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	fixture.name = "enemy"
	self.fixture = fixture

	Timer.delayedCall(10, self.startMoving, self)
	
	table.insert(self.scene.spritesOnScreen, self)

	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
end



function Thwomper:startMoving()

	self:addEventListener(Event.ENTER_FRAME, self.moveMe, self)

end



function Thwomper:moveMe()

	--print("move")

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		local spriteX, spriteY = self.body:getPosition()
		
		self.xDist = math.abs(self.scene.playerMovement.heroX - spriteX)
		self.yDist = math.abs(self.scene.playerMovement.heroY - spriteY)

		self.bodyX,self.bodyY = self.body:getPosition()
		
		if(self.phase == "up") then
		
			-- decide whether to stop or start ratchet based on distance
		
			
			if(self.xDist<350 and self.yDist<350) then
				
				if(not(self.ratchetPlay)) then
					self.ratchetPlay = true
					
					self.channel1:setPaused(false)

				end
			
			else
				if(self.ratchetPlay) then
					self.ratchetPlay = false
					if(self.channel1) then
						self.channel1:setPaused(true)
					end
				end
			
			end
		
			self.fixture.name = "nowt"
			self.body:setPosition(self.bodyX,self.bodyY-self.upSpeed)
			self.distanceCounter = self.distanceCounter + self.upSpeed
			
			-- reached top
			
			if(self.distanceCounter >= 110) then
				self.distanceCounter = 0
				self.phase = nil
				Timer.delayedCall(self.delayBetween, function() self.phase = "down" end)
			end
			
			
		elseif(self.phase == "down") then
		
			if(self.ratchetPlay) then
				self.ratchetPlay = false
				self.channel1:setPaused(true)
			end

			self.fixture.name = "enemy"
			self.body:setPosition(self.bodyX,self.bodyY+self.downSpeed)
			self.distanceCounter = self.distanceCounter + self.downSpeed
			
			-- reached bottom
			
			if(self.distanceCounter >= 110) then

				if(self.channel2) then
					self.channel2 = self.scene.thwompSound:play()
					self.channel2:setVolume(self.volume*self.scene.soundVol)
				end
				
				self.distanceCounter = 0
				self.phase = nil
				self.body:setPosition(self.bodyX, self.startY)
				Timer.delayedCall(self.delayBetween, function() self.phase = "up" end)
			end
			
		end
	
	end

end


function Thwomper:pause()

end



function Thwomper:resume()

end



-- cleanup function

function Thwomper:exit()
	
	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.moveMe, self)
	end
	
end

