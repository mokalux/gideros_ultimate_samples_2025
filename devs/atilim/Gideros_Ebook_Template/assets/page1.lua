Page1 = gideros.class(Sprite)

function Page1:init( pageNo, parent)
	self.no = pageNo

	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/bk1.png", true)))	

	self.toy =  Bitmap.new(TextureRegion.new(Texture.new("gfx/doll.png", true )))	
	self.toy:setX(400)
	self.toy:setY(300)

	self.ball =  Bitmap.new(TextureRegion.new(Texture.new("gfx/ball.png", true)))	
	self.ball:setX(200)
	self.ball:setY(700)	

	self.txt = Bitmap.new(TextureRegion.new(Texture.new("txt/1txt.png", true)))	
	self.txt:setX(10)
	self.txt:setY(10)	


	self:addChild(self.background)
	self:addChild(self.toy)	
	self:addChild(self.ball)
	self:addChild(self.txt)

	self.toy.isMoving = false
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)	
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)	
		
end

function Page1:onAddedToStage()
	-- we need mouse functions to interact with the toy
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end

function Page1:onRemovedFromStage()

	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end	

function Page1:onEnterFrame(event)
end

function Page1:onMouseDown(event)
	-- touch event begins here. you need to get the initial x and y, we will use them later
	if (self.toy:hitTestPoint(event.x, event.y) == true) then 
		self.toy.isMoving = true
		self.toy.x0 = event.x
		self.toy.y0 = event.y
		print("toy")
	end
	
end		

function Page1:onMouseUp(event)
	-- touch event ends here. we must get out of the mode.
	if (self.toy.isMoving == true) then  self.toy.isMoving = false end
		
end		

function Page1:onMouseMove(event)

	if (self.toy.isMoving == true) then  
		-- calculate the difference
		local dx = event.x - self.toy.x0
		local dy = event.y - self.toy.y0
		--store the new x,y of touch coordinates
		self.toy.x0 = event.x
		self.toy.y0 = event.y
		--set the new coordinates
		self.toy:setX(dx + self.toy:getX())
		self.toy:setY(dy + self.toy:getY())
	end
	
end		