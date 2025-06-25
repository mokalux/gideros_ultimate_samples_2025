TongueDoor = Core.class(Sprite)

function TongueDoor:init(scene,x,y,id)

	self.scene = scene
	self.x = x
	self.y = y
	self.speed = 4
	self.dist = 0
	self.distToMove = 400
	self.scene.layer0:addChild(self)

	table.insert(self.scene.tongueDoors, self)

	-- Add image
	
	local img = Bitmap.new(self.scene.atlas[9]:getTextureRegion("tongue.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)

	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true, fixedRotation = true}
	self.theShape = b2.PolygonShape.new()
	self.theShape:setAsBox(img:getWidth()/2,20,0,0,0)
	self.body = body

	local fixture = body:createFixture{shape = self.theShape, density = 999, friction = 3, restitution = 0}
	local filterData = {categoryBits = 2, maskBits = 1+4096}
	fixture:setFilterData(filterData)

	body.name = "Ground"
--	body.name2 = "Drag block"
	body.parent = self
	self.body = body
	--self.body:setGravityScale(0)
	
	self.body:setPosition(self.x,self.y)

	table.insert(self.scene.spritesOnScreen, self)
	
	-- set up sounds
	
	if(not(self.scene.dragBlockSound)) then
	
		self.scene.dragBlockSound = Sound.new("Sounds/drag object.wav")

	end
	
	table.insert(self.scene.pauseResumeExitSprites, self) -- for pausing, resuming and exiting events
	
end



function TongueDoor:openDoor()

	self.channel1 = self.scene.dragBlockSound:play(1)
	self.channel1:setVolume(.7*self.scene.soundVol)
	Timer.delayedCall(1800, function() 
		self.channel1:stop()
	end)

	self:addEventListener(Event.ENTER_FRAME, self.moveDoor, self)

end




function TongueDoor:moveDoor()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		local doorX,doorY = self.body:getPosition()
		self.body:setPosition(doorX+self.speed, doorY)
		
		self.dist = self.dist + self.speed
		
		if(self.dist >= self.distToMove) then
			self:removeEventListener(Event.ENTER_FRAME, self.moveDoor, self)
		end

	end
end


function TongueDoor:pause()
	
end



function TongueDoor:resume()

end



-- cleanup function

function TongueDoor:exit()
	
	if(self:hasEventListener(Event.ENTER_FRAME)) then
		self:removeEventListener(Event.ENTER_FRAME, self.moveDoor, self)
	end
	
end

