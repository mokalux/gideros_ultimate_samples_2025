CLASS_carro = Core.class(Sprite)

function CLASS_carro:init()
	self.pack = TexturePack.new("example2_gfx.txt", "example2_gfx.png")
	self.base = Bitmap.new(self.pack:getTextureRegion("basecarrarmato.png"))
	self.base:setAnchorPoint(.5, .5)
	
	self.cannoneAngle = 0
	self.angle = 0
	self.cannone = Bitmap.new(self.pack:getTextureRegion("cannone.png"))
	self.cannone:setAnchorPoint(.22, .5)

	self.xPos = application:getContentWidth()/2
	self.yPos = application:getContentHeight()/2
	
	self:setPosition(self.xPos, self.yPos)

	self:addChild(self.base)
	self:addChild(self.cannone)
end

function CLASS_carro:move(direction, speed)
	self.angle = direction
	self.xPos = self.xPos + math.cos (direction) * speed 
	self.yPos = self.yPos + math.sin (direction) * speed
	if self.xPos > application:getLogicalHeight() then	
		self.xPos = 0
	elseif self.xPos < 0 then 
		self.xPos = application:getLogicalHeight()
	end
	if self.yPos > application:getLogicalWidth() then	
		self.yPos = 0
	elseif self.yPos < 0 then 
		self.yPos = application:getLogicalWidth()
	end
	self:setRotation(math.deg(direction))
	self:setPosition(self.xPos, self.yPos)
end

function CLASS_carro:rotateCannone(direction)
	self.cannoneAngle = direction-self.angle
	self.cannone:setRotation( math.deg(self.cannoneAngle))
end

