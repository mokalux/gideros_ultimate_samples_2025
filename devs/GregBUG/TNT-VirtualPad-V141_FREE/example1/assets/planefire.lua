CLASS_fire = Core.class(Sprite)

function CLASS_fire:init(x, y)
	self.pack = TexturePack.new("tntskinpad.txt", "tntskinpad.png")
	self.fire =	Bitmap.new(self.pack:getTextureRegion("fire.png"))
	self.fire:setAnchorPoint(.5, .5)
	self.xPos = x
	self.yPos = y
	self:setPosition(self.xPos, self.yPos)
	self:addChild(self.fire)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function CLASS_fire:onEnterFrame(Event)
	self.yPos = self.yPos - 160 *Event.deltaTime
	self:setPosition(self.xPos, self.yPos)
	if self.yPos < 0 then
		self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
		self:removeChild(self.fire)
	end
end

