MasherUpDown = Core.class(Sprite)

function MasherUpDown:init(scene,x,y,speed,yMove,atlas)

	self.yMove = tonumber(yMove)
	self.speed = speed
	self.posSpeed = speed
	
	self.distanceCounter = 0
	self.speed = speed

	self.scene = scene
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("masher up down.png"));
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.layer0:addChild(self)
	self.img = img
	
	-- Masher body

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(img:getWidth()/2,30,0,0,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0, isSensor =true}

	fixture.parentSprite = self
	fixture.name = "masher"
	self.mainFixture = fixture
	self.body = body
	self.body.name = "Ground"

	local filterData = {categoryBits = 64, maskBits = 1+4+8}
	fixture:setFilterData(filterData)

	table.insert(self.scene.spritesOnScreen, self)

	-- Masher stinger fixture - hits hero

	poly:setAsBox(130,img:getHeight()/2-25,0,0,0)

	local fixture = body:createFixture{shape = poly, density = 0, friction = 0, restitution = 0,isSensor =true}
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




function MasherUpDown:moveMe()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		self.bodyX,self.bodyY = self.body:getPosition()
		self.distanceCounter = self.distanceCounter + self.posSpeed
		
		self.body:setPosition(self.bodyX,self.bodyY+self.speed)
			
		if(self.distanceCounter >= self.yMove) then
			self.distanceCounter = 0
			self.speed = self.speed * -1
			
			self.channel2 = self.scene.masherHitSound:play()
			self.channel2:setVolume(self.volume*self.scene.soundVol)
			
		end
	
	end
		
end



function MasherUpDown:pause()
	
end



function MasherUpDown:resume()

end




function MasherUpDown:exit()
	
	self:removeEventListener(Event.ENTER_FRAME, self.moveMe, self)
	
end
