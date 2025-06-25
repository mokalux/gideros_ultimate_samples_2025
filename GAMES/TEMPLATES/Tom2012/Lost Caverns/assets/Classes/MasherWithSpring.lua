MasherWithSpring = Core.class(Sprite)

function MasherWithSpring:init(scene,x,y,speed,xMove,yMove,flip,angle,atlas)

	self.xMove = xMove
	self.yMove = yMove
	self.speed = speed
	self.posSpeed = speed
	
	if(self.xMove) then
		self.maxMove = self.xMove
		if(self.maxMove<0) then
			self.maxMove = self.maxMove * -1
		end
	else
		self.maxMove = self.yMove
		if(self.yMove < 0) then
			self.speed = -self.speed
			self.maxMove = self.maxMove * -1
		end
	end
	
	
	self.distanceCounter = 0
	self.scene = scene
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("masher left right.png"));
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.layer0:addChild(self)
	self.img = img
	
	-- If it was flipped
	if(flip) then
		self.img:setScaleX(1)
		self.speed = -self.speed 
	end
	


	-- Masher body

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	body:setAngle(angle)
	
	local poly = b2.PolygonShape.new()
	
	if(flip) then
		poly:setAsBox(img:getWidth()/2-40,90,-40,0,0)
	else
		poly:setAsBox(img:getWidth()/2-40,90,40,0,0)
	end
	
	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}

	fixture.parentSprite = self
	fixture.name = "masher"
	self.mainFixture = fixture
	self.body = body
	self.body.name = "Ground"

	local filterData = {categoryBits = 64, maskBits = 1+4+8}
	fixture:setFilterData(filterData)
	
	
	
	local poly = b2.PolygonShape.new()
	
	if(flip) then
		poly:setAsBox(20,20,-140,-70,0)
	else
		poly:setAsBox(30,5,-100,-85,0)
	end
	
	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}

	fixture.parentSprite = self
	fixture.name = "masher"
	self.mainFixture = fixture
	self.body = body
	
	self.body.name = "Ground"

	local filterData = {categoryBits = 64, maskBits = 1+4+8}
	fixture:setFilterData(filterData)
	
	
	
	

	table.insert(self.scene.spritesOnScreen, self)



	-- Masher stinger fixture - hits hero

	local poly = b2.PolygonShape.new()
	if(flip) then
		poly:setAsBox(40,img:getHeight()/2-18,100,0,0)
	else
		poly:setAsBox(30,img:getHeight()/2-18,-100,0,0)
	end
	
	
	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0}
	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)
	
	fixture.name = "enemy"


	
	-- sounds
	
	self.maxVolume = .2
	self.volume = 0
		
	if(not(self.scene.masherMoveSound)) then
	
		self.scene.masherMoveSound = Sound.new("Sounds/masher move.wav")
		self.scene.masherHitSound = Sound.new("Sounds/masher hit.wav")
		
	end
	
	-- set up looping sound
	self.channel1 = self.scene.masherMoveSound:play(0,math.huge)
	self.channel1:setVolume(self.volume*self.scene.soundVol)
	
	-- add channel to table for volume by distance
	table.insert(self.scene.spritesWithVolume, self)
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	self:addEventListener(Event.ENTER_FRAME, self.moveMe, self)

	


end



function MasherWithSpring:moveMe()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		self.bodyX,self.bodyY = self.body:getPosition()
		self.distanceCounter = self.distanceCounter + self.posSpeed

		if(self.xMove) then
			self.body:setPosition(self.bodyX+self.speed,self.bodyY)
		else
			self.body:setPosition(self.bodyX,self.bodyY+self.speed)
		end
		

		
		if(self.distanceCounter >= self.maxMove) then
		
			self.channel2 = self.scene.masherHitSound:play()
			self.channel2:setVolume(self.volume*self.scene.soundVol)
		
			self.distanceCounter = 0
			self.speed = self.speed * -1
		end
	
	end

end



function MasherWithSpring:pause()
	
end



function MasherWithSpring:resume()

end


-- cleanup function

function MasherWithSpring:exit()

	self:removeEventListener(Event.ENTER_FRAME, self.moveMe, self)

end
