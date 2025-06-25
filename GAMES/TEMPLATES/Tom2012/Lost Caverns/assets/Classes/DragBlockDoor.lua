DragBlockDoor = Core.class(Sprite)

function DragBlockDoor:init(scene,x,y)

	self.scene = scene
	self.x = x
	self.y = y
	self.speed = .45
	self.dist = 0
	self.distToMove = 70

	self:makeDoor("left")
	self:makeDoor("right")

	self.scene.behindRube:addChild(self)
	
end




function DragBlockDoor:makeDoor(doorType)

	if(doorType=="left") then

		self.bodyX = -51
		self.image = "drag block door left.png"
	else
		self.bodyX = 49
		self.image = "drag block door right.png"
	end

	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true, fixedRotation = true}
	self.theShape = b2.PolygonShape.new()
	self.theShape:setAsBox(49,14,0,0,0)

	local fixture = body:createFixture{shape = self.theShape, density = 999, friction = 3, restitution = 0}
	local filterData = {categoryBits = 512, maskBits = 1}
	fixture:setFilterData(filterData)

	body.name = "Ground"
	body.name2 = "Drag block"
	body.parent = self
	self.body = body
	
	if(doorType=="left") then
		self.leftBody = body
		self.leftImg = img
		self.imgX = -104
	else
		self.rightBody = body
		self.imgX = 0
	end

	--table.insert(self.scene.spritesOnScreen, self)
	self.body:setPosition(self.x+self.bodyX,self.y)
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion(self.image))
	img:setAnchorPoint(0,.5)
	self:addChild(img)
	
	if(doorType=="left") then
		self.leftBody = body
		self.leftImg = img
		self.imgX = -114
	else
		self.rightBody = body
		self.rightImg = img
		self.imgX = -1
	end
	
	img:setX(self.imgX)
	
	

end



function DragBlockDoor:openDoors()

	self:addEventListener(Event.ENTER_FRAME, self.moveDoors, self)
	
	self.channel1 = self.scene.dragBlockSound:play()
	self.channel1:setVolume(.3*self.scene.soundVol)
end



function DragBlockDoor:moveDoors()

	if(not(self.scene.paused) and not(self.scene.gameEnded)) then

		local doorX,doorY = self.leftBody:getPosition()
		self.leftBody:setPosition(doorX-self.speed, doorY)
		self.leftImg:setX(self.leftImg:getX()-self.speed)
		
		local doorX,doorY = self.rightBody:getPosition()
		self.rightBody:setPosition(doorX+self.speed, doorY)
		self.rightImg:setX(self.rightImg:getX()+self.speed)
		
		self.dist = self.dist + self.speed
		
		if(self.dist >= self.distToMove) then
			self:removeEventListener(Event.ENTER_FRAME, self.moveDoors, self)
		end
		
	end

end
