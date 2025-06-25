DropDoor = Core.class(Sprite)

function DropDoor:init(scene,x,y)

	self.scene = scene

	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("drop door.png"));
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	self.scene.behindRube:addChild(self)
	self.img = img
	
	-- Body

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true}
	body:setPosition(x, y)
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(18,55,0,0,0)

	local fixture = body:createFixture{shape = poly, density = 999999, friction = 0, restitution = 0}
	fixture.parent = self
	fixture.name = "block spike"
	self.body = body

	local filterData = {categoryBits = 256, maskBits = 1}
	fixture:setFilterData(filterData)

	table.insert(self.scene.spritesOnScreen, self)
	
	table.insert(self.scene.dropDoors, self)
	self.moved = 0
	self.speed = 0
	self.maxSpeed = 20
	self.maxMove = 100
	self.acceleration = .3
	
	
	-- sounds
	
	self.volume = .25
		
	if(not(self.scene.doorSlamSound)) then
	
		self.scene.doorSlamSound = Sound.new("Sounds/door slam.wav")
		
	end
 
end


function DropDoor:close()

	if(not(self.closed)) then

		Timer.delayedCall(50, self.closeSound, self)
		self.closed = true
		self:addEventListener(Event.ENTER_FRAME, self.closeMove, self)
	end
	
end



function DropDoor:closeSound()

	if(not(self.scene.playedDoorSound)) then

		self.scene.playedDoorSound = true
			
		local channel = self.scene.doorSlamSound:play()
		channel:setVolume(self.volume*self.scene.soundVol)
	
	end

end


function DropDoor:closeMove()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then
	
		local x,y = self.body:getPosition()
		self.body:setPosition(x,y+self.speed)
		self.moved = self.moved + self.speed
		if(self.speed < self.maxSpeed) then
			self.speed = self.speed + self.acceleration
		end
		
		if(self.moved>= self.maxMove) then
			self:removeEventListener(Event.ENTER_FRAME, self.closeMove, self)
		end
	
	end

end




function DropDoor:open()

	self:addEventListener(Event.ENTER_FRAME, self.openMove, self)
	self.moved = true

	self.moved = 0
	self.speed = 3
	self.maxMove = 93


end


function DropDoor:openMove()
	
	local x,y = self.body:getPosition()
	self.body:setPosition(x,y-self.speed)
	self.moved = self.moved + self.speed
	
	if(self.moved >= self.maxMove) then
		self:removeEventListener(Event.ENTER_FRAME, self.openMove, self)
	end

end













