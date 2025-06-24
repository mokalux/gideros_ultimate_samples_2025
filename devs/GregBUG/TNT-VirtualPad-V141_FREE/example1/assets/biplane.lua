CLASS_biPlane = Core.class(Sprite)

function CLASS_biPlane:init()
	self.pack = TexturePack.new("tntskinpad.txt", "tntskinpad.png")
	self.anim = {
		Bitmap.new(self.pack:getTextureRegion("plane1.png")),
		Bitmap.new(self.pack:getTextureRegion("plane2.png")),
		Bitmap.new(self.pack:getTextureRegion("plane3.png")),
	}
	self.protection = Bitmap.new(self.pack:getTextureRegion("tntvpad_base.png"))
		self.protection:setAnchorPoint(.5, .5)
	for i = 1, 3 do
		self.anim[i]:setAnchorPoint(.5, .5)
	end
	self.planeAnim = MovieClip.new{
		{1, 3, self.anim[1]}, 
		{4, 7, self.anim[2]},    
		{8, 11, self.anim[3]}   
	}
	self.planeAnim:setGotoAction(11, 1)
	self.xPos = application:getContentWidth()/2
	self.yPos = application:getContentHeight()/2
	self:setPosition(self.xPos, self.yPos)
	self:addChild(self.planeAnim)
	self.protection:setVisible(false)
	self:addChild(self.protection)
end

function CLASS_biPlane:move(direction, speed)
	if direction == 0 then
		-- 0 move right
		self.xPos = self.xPos + speed
	elseif direction == 1 then
		-- 1 move right-down
		self.xPos = self.xPos + speed
		self.yPos = self.yPos + speed
	elseif direction == 2 then
		-- 2 move down
		self.yPos = self.yPos + speed
	elseif direction == 3 then
		-- 3 move left down
		self.xPos = self.xPos - speed
		self.yPos = self.yPos + speed
	elseif direction == 4 then
		-- 4 move left
		self.xPos = self.xPos - speed
	elseif direction == 5 then
		-- 5 move left-up
		self.xPos = self.xPos - speed
		self.yPos = self.yPos - speed
	elseif direction == 6 then
		-- 6 move up
		self.yPos = self.yPos - speed
	elseif direction == 7 then
		-- 6 move right-up
		self.xPos = self.xPos + speed
		self.yPos = self.yPos - speed
	end
	if self.xPos > application:getContentWidth() then 
		self.xPos = 0
	elseif self.xPos < 0 then 
		self.xPos = application:getContentWidth() 
	end
	if self.yPos > application:getContentHeight() then 
		self.yPos = 0
	elseif self.yPos < 0 then 
		self.yPos = application:getContentHeight() 
	end
	self:setPosition(self.xPos, self.yPos)
end
