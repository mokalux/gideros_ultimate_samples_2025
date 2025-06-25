ThinSpike = Core.class(Sprite)

function ThinSpike:init(scene,x,y,angle,flip,atlas)

	self.scene = scene

	if(math.random(1,2)==1) then
		self.type = "thin spike 1.png"
	else
		self.type = "thin spike 2.png"
	end
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion(self.type));
	img:setAnchorPoint(.5,1)
	self:addChild(img)
	self.spike = img
	
	self.scene.layer0:addChild(self)
	
	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("thin spike hole.png"));
	img:setAnchorPoint(.5,.5)
	self.hole = img
	
	if(flip) then
		self.hole:setScaleX(-1)
	end

	self.scene.rube1:addChild(img)
	img:setPosition(x,y)

	-- Body

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(5,130,0,-130,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0, isSensor=true}
	fixture.name = "enemy"
	self.body = body

	local filterData = {categoryBits = 128, maskBits = 8}
	fixture:setFilterData(filterData)

	self.body:setPosition(x,y+270)
	self.spike:setY(270)
	
	self.speed = 0
	self.acceleration = .2
	self.distMoved = 0
	self.maxDist = 250
	
	table.insert(self.scene.thinSpikes, self)
	
	-- sounds
	
	self.volume = .25
		
	if(not(self.scene.thinSpikeSound)) then
	
		self.scene.thinSpikeSound = Sound.new("Sounds/spike slam.wav")
		
	end
	
	if(not(self.scene.objectSpikeSound)) then

		self.scene.openSound = Sound.new("Sounds/spike open.wav")
		
	end

	self.scene:addEventListener("onExit", self.onExit, self)
	
end





function ThinSpike:close()

	self:addEventListener(Event.ENTER_FRAME, self.closeMe, self)

end


function ThinSpike:closeMe()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		if(not(self.scene.thinSpikeSoundPlayed)) then
		
			self.scene.thinSpikeSoundPlayed = true
			
			Timer.delayedCall(400, self.spikeSound, self)
				

		
		end
		

		self.speed = self.speed + self.acceleration

		local x,y = self.body:getPosition()
		self.body:setPosition(x,y-self.speed)
		self.spike:setPosition(self.spike:getX(),self.spike:getY()-self.speed)
		self.distMoved = self.distMoved + self.speed
		
		if(self.distMoved > self.maxDist) then
			self:removeEventListener(Event.ENTER_FRAME, self.closeMe, self)
			Timer.delayedCall(1000, self.open,self)
			self.body:setActive(false)
		end
	
	end

end




function ThinSpike:spikeSound()

	local channel = self.scene.thinSpikeSound:play()
	channel:setVolume(self.volume*self.scene.soundVol)

end





function ThinSpike:open()

	if(not(self.scene.openedDropDoorSound)) then
	
		self.scene.openedDropDoorSound = true
		
		Timer.delayedCall(1200, self.openSound, self)

		Timer.delayedCall(1800, self.stopOpenSound, self)

		
	end

	self.speed = 0
	self.acceleration = .1
	self.maxSpeed = 4
	self.distMoved = 0
	self.maxDist = 260

	self:addEventListener(Event.ENTER_FRAME, self.openMe, self)

end



function ThinSpike:openSound()

	self.channel2 = self.scene.openSound:play()
	self.channel2:setVolume(1*self.scene.soundVol)

end




function ThinSpike:stopOpenSound()

	self.channel2:setPaused(true)

end



function ThinSpike:openMe()

	if(self.speed < self.maxSpeed) then
		self.speed = self.speed + self.acceleration
	end

	local x,y = self.body:getPosition()
	self.body:setPosition(x,y+self.speed)
	self.spike:setPosition(self.spike:getX(),self.spike:getY()+self.speed)
	self.distMoved = self.distMoved + self.speed
	
	if(self.distMoved > self.maxDist) then
		self:removeEventListener(Event.ENTER_FRAME, self.openMe, self)
	end

end






-- cleanup function

function ThinSpike:onExit()

	--self.upTween:setPaused(true)
	--self.downTween:setPaused(true)
	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end
	self.scene:removeEventListener("onExit", self.onExit, self)
	
end



