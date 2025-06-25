CLASS_fire = Core.class(Sprite)

function CLASS_fire:init(x, y, direction)
	self.pack = TexturePack.new("example2_gfx.txt", "example2_gfx.png")
	self.fire =	Bitmap.new(self.pack:getTextureRegion("fire.png"))
	self.fire:setAnchorPoint(.5, .5)
	self.direction = direction
	self.xPos = x
	self.yPos = y
	self:setPosition(self.xPos, self.yPos)
	self:addChild(self.fire)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function CLASS_fire:onEnterFrame(Event)
	self.xPos = self.xPos + math.cos(self.direction) * (260 *Event.deltaTime)
	self.yPos = self.yPos + math.sin(self.direction) * (260 *Event.deltaTime)
	self:setPosition(self.xPos, self.yPos)
	if self.xPos < 0 or self.yPos < 0 or self.xPos > application:getContentWidth() or self.yPos > application:getContentHeight() then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		self:removeChild(self.fire)
	end
end

