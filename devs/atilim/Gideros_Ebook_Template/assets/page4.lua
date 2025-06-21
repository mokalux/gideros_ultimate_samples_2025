Page4 = gideros.class(Sprite)

function Page4:init()
	self.no = pageNo

	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/bk4.png", true)))	

	self.bird =  Bitmap.new(TextureRegion.new(Texture.new("gfx/bird.png", true )))	
	self.bird:setX(400)
	self.bird:setY(300)

	self.skip =  Bitmap.new(TextureRegion.new(Texture.new("gfx/skip.png", true)))	
	self.skip:setX(100)
	self.skip:setY(400)	
	
	self.txt = Bitmap.new(TextureRegion.new(Texture.new("txt/4txt.png", true)))	
	self.txt:setX(400)
	self.txt:setY(800)		

	self:addChild(self.background)

	self:addChild(self.skip)
	self:addChild(self.txt)
	self:addChild(self.bird)		
	self.sound = Sound.new("sound/birds013.wav")

	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)	
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)	
end


function Page4:onAddedToStage()
	-- we need mouse functions to interact with the toy
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
end

function Page4:onRemovedFromStage()

end	



function Page4:onMouseDown(event)
	-- touch event begins here. you need to get the initial x and y, we will use them later
	if (self.bird:hitTestPoint(event.x, event.y) == true) then 
		self.sound:play()
		self.bird:setX(math.random(1,700) + 50)
		self.bird:setY(math.random(1,800) + 50)
	end
	
end		
