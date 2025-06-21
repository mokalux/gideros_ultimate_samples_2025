Page3 = gideros.class(Sprite)

function Page3:init()
	self.no = pageNo

	self.background = Bitmap.new(TextureRegion.new(Texture.new("gfx/bk3.jpg", true)))	

	self.elephant = Bitmap.new(TextureRegion.new(Texture.new("gfx/elephant.png", true)))	
	self.elephant:setX(206)
	self.elephant:setY(275)
	
	self.door =  Bitmap.new(TextureRegion.new(Texture.new("gfx/door.png", true )))	
	self.door:setAnchorPoint(1,0)
	self.door:setX(538)
	self.door:setY(75)
	self.door.scaleX = 1
	self.door.inc = -0.001

	self.water =  Bitmap.new(TextureRegion.new(Texture.new("gfx/water.png", true)))	
	self.water:setX(60)
	self.water:setY(500)	
	
	self.txt = Bitmap.new(TextureRegion.new(Texture.new("txt/3txt.png", true)))	
	self.txt:setX(300)
	self.txt:setY(800)	

	self:addChild(self.background)

	self:addChild(self.water)
	self:addChild(self.elephant)	
	self:addChild(self.door)
	self:addChild(self.txt)
	
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)	
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)	
end


function Page3:onAddedToStage()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Page3:onRemovedFromStage()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end	

function Page3:onEnterFrame(event)
	self.door.scaleX = self.door.scaleX  + self.door.inc
	if (self.door.scaleX < 0.85) and self.door.inc < 0  then self.door.inc = -self.door.inc end 
	if (self.door.scaleX > 1) and self.door.inc > 0 then self.door.inc = -self.door.inc end 
	
	self.door:setScaleX(self.door.scaleX)
end