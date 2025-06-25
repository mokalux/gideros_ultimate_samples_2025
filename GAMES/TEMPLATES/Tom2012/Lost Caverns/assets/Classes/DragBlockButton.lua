DragBlockButton = Core.class(Sprite)

function DragBlockButton:init(scene,x,y,id)

	self.scene = scene
	self.dist = 0 -- remember how much button has moved
	self.id = tonumber(id) -- index of door I open
	self.speed = .2
	self.scene.behindRube:addChild(self)

	
	
	-- Button image
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("drag block button.png"))
	img:setAnchorPoint(.5,.5)
	self:addChild(img)
	

	-- Button base image
	
	local img = Bitmap.new(self.scene.atlas[2]:getTextureRegion("drag block button skirt.png"))
	img:setAnchorPoint(.5,.5)
	self.scene.rube2:addChild(img)
	img:setPosition(x,y+29)
	
	
	-- Add physics

	local body = self.scene.world:createBody{type = b2.STATIC_BODY,allowSleep = true,fixedRotation = true}
	self.theShape = b2.PolygonShape.new()
	self.theShape:setAsBox(36,30,0,-5,0)

	local fixture = body:createFixture{shape = self.theShape, density = 999, friction = .3, restitution = 0}
	local filterData = {categoryBits = 1024, maskBits = 1+256}
	fixture:setFilterData(filterData)
	fixture.name = "drag block button"
	fixture.parent = self

	body.name = "Ground"

	body.parent = self
	self.body = body

	self.body:setPosition(x,y)
	table.insert(self.scene.dragBlocks, self) -- so will be included in collisions
	table.insert(self.scene.spritesOnScreen, self) -- move image when box2D object moves

end





function DragBlockButton:lowerButton()

	self:addEventListener(Event.ENTER_FRAME, self.makeButtonMoveDown, self)
	self.pressed = true
	
end



function DragBlockButton:makeButtonMoveDown()
	
	local buttonX,buttonY = self.body:getPosition()
	self.body:setPosition(buttonX, buttonY+self.speed)
	
	self.dist = self.dist + self.speed
	
	if(self.dist >= 20) then
	
		self:removeEventListener(Event.ENTER_FRAME, self.makeButtonMoveDown, self)
		self.scene.doors[tonumber(self.id)]:openDoors()
		



		if(self.scene.dragBlocks[self.id].correctingRotation) then
			self.scene.dragBlocks[self.id]:stopCorrectingRotation()
		end

	end 

end
