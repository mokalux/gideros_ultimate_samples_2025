Spike = Core.class(Sprite)

function Spike:init(scene,x,y,angle,atlas)

	self.moveRange = 115
	self.speed = 1.6
	self.distanceCounter = 0
	
	-- These variables make it wobble
	self.hDir = left
	self.hDirCounter = 0
	self.hMove = .5
	self.hMovePos = self.hMove
	self.hMax = 3

	self.scene = scene

	local img = Bitmap.new(self.scene.atlas[atlas]:getTextureRegion("spike.png"));
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.behindRube:addChild(self)
	self.scene.behindRube:addChild(self)
	self.img = img
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
	-- Body

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(13,60,-2,0,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}
	fixture.parent = self
	fixture.name = "block spike"
	self.body = body

	local filterData = {categoryBits = 512, maskBits = 1+2+4+4096}
	fixture:setFilterData(filterData)

	table.insert(self.scene.spritesOnScreen, self)
	
	self.angle = angle *-1
	self.body:setAngle(self.angle)
	
	if(not(self.scene.objectSpikeSound)) then
		self.scene.objectSpikeSound = Sound.new("Sounds/object hit spike.wav")
	end
	
	
	
	if(not(self.scene.openSound)) then
		self.scene.openSound = Sound.new("Sounds/spike open.wav")
	end
	
end





function Spike:open()

	if(not(self.moved)) then
		self:addEventListener(Event.ENTER_FRAME, self.moveMe, self)
		self.moved = true
		local channel1 = self.scene.objectSpikeSound:play()
		channel1:setVolume(.3*self.scene.soundVol)
		local channel2 = self.scene.openSound:play()
		channel2:setVolume(1*self.scene.soundVol)
	end

end


function Spike:moveMe()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		local moveAngle = math.rad(math.deg(self.angle)-90)
		

		local currentX, currentY = self.body:getPosition()

		local nextX = currentX+(math.cos(moveAngle)*self.speed)
		local nextY = currentY+(math.sin(moveAngle)*self.speed)

		self.body:setPosition(nextX, nextY)
		
		-- If travelled horizontally past wobble then go other way
		self.hDirCounter = self.hDirCounter + self.hMovePos
		
		self.img:setX(self.img:getX()+self.hMove)
		
		
		if(self.hDirCounter >= self.hMax) then
			self.hMove = self.hMove * -1
			self.hDirCounter = 0
		end
		
		self.distanceCounter = self.distanceCounter + self.speed
		
		if(self.distanceCounter >= self.moveRange) then
			self:removeEventListener(Event.ENTER_FRAME, self.moveMe, self)
						self.body.destroyed = true
				self.scene.world:destroyBody(self.body) -- remove physics body

		end

	end
	
end








function Spike:pause()
	
end



function Spike:resume()

end




function Spike:exit()

	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end

end





